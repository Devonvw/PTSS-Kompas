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
    private let genericError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Er is iets fout gegaan."])
    
    private init() {}
    
    
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: String?]? = nil,
        body: Any? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type = T.self,  // Default response type is the generic type T
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard var url = URL(string: endpoint.hasSuffix("/") ? String(endpoint.dropLast()) : endpoint, relativeTo: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        if let parameters {
            let filteredParameters = parameters.compactMapValues { value in
                value?.isEmpty == false ? value : nil
            }
            
            guard let appendedURL = url.appendingQueryParameters(filteredParameters) else {
                completion(.failure(.invalidURL))
                return
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
                    print(body)
                    completion(.failure(.unknown(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid body data"])) ))
                    return
                }
                
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print(error)
                completion(.failure(.unknown(error: error)))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.unknown(error: error)))
                return
            }
            
            //                guard let data = data else {
            //                    completion(.failure(.missingData))
            //                    return
            //                }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"]))))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                if responseType == Never.self {
                    // If the responseType is Never, just return success with an empty result
                    completion(.success(() as! T))  // Force cast `()` as T (Never)
                } else {
                    do {
                        guard let data = data else {
                            completion(.failure(.missingData))
                            return
                        }
                        // Otherwise decode the data as the expected type T
                        let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        print(error)
                        completion(.failure(.decodingFailed))
                    }
                }
            case 400...499:
                guard let data = data else {
                    completion(.failure(.missingData))
                    return
                }
                
                let message = (try? JSONDecoder().decode(ResponseError.self, from: data).localizedDescription) ?? "Client error"
                completion(.failure(.serverError(statusCode: httpResponse.statusCode, message: message)))
            case 500...599:
                completion(.failure(.serverError(statusCode: httpResponse.statusCode, message: "Server error occurred")))
            default:
                completion(.failure(.unknown(error: NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected error"]))))
            }
            
        }.resume()
    }
    
    
    
    
    private func getBearerToken() -> String? {
        return "ABC"
        //        return KeychainManager.shared.retrieveToken(for: tokenKey)
    }
}
