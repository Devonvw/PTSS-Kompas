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

final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = Config.APIBaseURL
    private let tokenKey = "jwt_token"
    
    private init() {}
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: String?]? = nil,
        body: Any? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type = T.self
    ) async throws -> T {
        // Build the URL
        guard var url = URL(string: endpoint.hasSuffix("/") ? String(endpoint.dropLast()) : endpoint, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }
        
        if let parameters {
            let filteredParameters = parameters.compactMapValues { value in
                value?.isEmpty == false ? value : nil
            }
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
        
        if let token = getBearerToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Attach body if needed
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
                if responseType == Never.self {
                    return () as! T // Force cast `()` as T (Never)
                } else {
//                    guard let data = data else {
//                        throw NetworkError.missingData
//                    }
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
    
    private func getBearerToken() -> String? {
        return "ABC"
        // return KeychainManager.shared.retrieveToken(for: tokenKey)
    }
}

// Add this extension for URL parameter handling if not already present
extension URL {
    func appendingQueryParameters(_ parameters: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
}
