//
//  NetworkManager.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

enum NetworkError: LocalizedError {
    case invalidURL
    case missingData
    case decodingFailed
    case serverError(statusCode: Int, message: String)
    case unknown(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Er is iets fout gegaan." //"The URL provided was invalid."
        case .missingData:
            return "Er is iets fout gegaan." //"No data was received from the server."
        case .decodingFailed:
            return "Er is iets fout gegaan." //"Failed to decode the response from the server."
        case .serverError(let statusCode, let message):
            return message
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

struct VoidResponse: Decodable {}

final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = Config.APIBaseURL
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let authRefreshEndpoint = "auth/refresh"

    private init() {
        _ = KeychainManager.shared.saveToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c", for: accessTokenKey)
        _ = KeychainManager.shared.saveToken("dGhpcyBpcyBhIHNhbXBsZSByZWZyZXNoIHRva2VuIHZhbHVlIHdpdGggYSBsb25nZXIgZXhwaXJhdGlvbiB0aW1l", for: refreshTokenKey)
    }

    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: String?]? = nil,
        body: Any? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type = T.self
    ) async throws -> T {
        try await ensureTokenValidity()

        guard var url = URL(string: endpoint.hasSuffix("/") ? String(endpoint.dropLast()) : endpoint, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }

        if let parameters {
            let filteredParameters = parameters.compactMapValues { $0?.isEmpty == false ? $0 : nil }
            guard let appendedURL = url.appendingQueryParameters(filteredParameters) else {
                throw NetworkError.invalidURL
            }
            url = appendedURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if [.POST, .PUT, .PATCH].contains(method), headers?["Content-Type"] == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        if let token = getBearerToken(), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        if let body {
            do {
                let jsonData: Data
                if let arrayBody = body as? [Any] {
                    jsonData = try JSONSerialization.data(withJSONObject: arrayBody, options: [])
                } else if let dictBody = body as? [String: Any] {
                    jsonData = try JSONSerialization.data(withJSONObject: dictBody, options: [])
                } else if let encodableBody = body as? Encodable {
                    jsonData = try JSONEncoder().encode(EncodableWrapper(encodableBody))
                } else {
                    throw NetworkError.unknown(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid body data"]))
                }

                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw NetworkError.unknown(error: error)
            }
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))
            }

            switch httpResponse.statusCode {
            case 200...299:
                if responseType == VoidResponse.self {
                    return VoidResponse() as! T
                } else {
                    return try JSONDecoder().decode(responseType, from: data)
                }
            case 400...499:
                let message = (try? JSONDecoder().decode(ResponseError.self, from: data).localizedDescription) ?? "Client error"
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: message)
            case 500...599:
                throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: "Server error occurred")
            default:
                throw NetworkError.unknown(error: NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected error"]))
            }
        } catch {
            throw NetworkError.unknown(error: error)
        }
    }

    private func ensureTokenValidity() async throws {
        guard let accessToken = getBearerToken() else {
            return
        }

        do {
            if let isExpired = try isTokenExpired(accessToken), isExpired {
                try await refreshToken()
            }
        } catch {
            throw NetworkError.unknown(error: error)
        }
    }

    private func isTokenExpired(_ token: String) throws -> Bool? {
        let payload = try decode(jwtToken: token)
        guard let exp = payload["exp"] as? TimeInterval else {
            return nil
        }
        let currentTime = Date().timeIntervalSince1970
        return currentTime > exp
    }

    private func decode(jwtToken jwt: String) throws -> [String: Any] {
        enum DecodeErrors: Error {
            case badToken
            case other
        }

        func base64Decode(_ base64: String) throws -> Data {
            let base64 = base64
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
            guard let decoded = Data(base64Encoded: padded) else {
                throw DecodeErrors.badToken
            }
            return decoded
        }

        func decodeJWTPart(_ value: String) throws -> [String: Any] {
            let bodyData = try base64Decode(value)
            let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
            guard let payload = json as? [String: Any] else {
                throw DecodeErrors.other
            }
            return payload
        }

        let segments = jwt.components(separatedBy: ".")
        guard segments.count > 1 else { throw DecodeErrors.badToken }
        return try decodeJWTPart(segments[1])
    }

    private func refreshToken() async throws {
        guard let refreshToken = KeychainManager.shared.retrieveToken(for: refreshTokenKey) else {
            throw NetworkError.unknown(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing refresh token"]))
        }

        print("refreshtoken")
        let body: [String: String] = ["refreshToken": refreshToken]
        let response: AuthResponse = try await request(
            endpoint: authRefreshEndpoint,
            method: .POST,
            body: body,
            responseType: AuthResponse.self
        )

        _ = KeychainManager.shared.saveToken(response.accessToken, for: accessTokenKey)
    }

    private func getBearerToken() -> String? {
        KeychainManager.shared.retrieveToken(for: accessTokenKey)
    }
}

extension URL {
    func appendingQueryParameters(_ parameters: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
}
