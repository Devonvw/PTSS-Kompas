//
//  NetworkManager.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

/// Enum for HTTP methods
enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

/// Network Manager to handle API calls
final class NetworkManager {
    static let shared = NetworkManager() // Singleton instance
    private let baseURL = Config.APIBaseURL
    private let tokenKey = "jwt_token"
    
    private init() {}
    
    /// Perform a network request
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: [String: String?]? = nil,
        body: Any? = nil,  // The body is of type Any to support arrays or dictionaries
        headers: [String: String]? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        // Construct the URL
        guard var url = URL(string: endpoint, relativeTo: baseURL) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Er is iets fout gegaan."])))
            return
        }
        
        // Append query parameters if provided
        if let parameters {
            guard let appendedURL = url.appendingQueryParameters(parameters) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Er is iets fout gegaan."])))
                return
            }
            url = appendedURL
        }
        
        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Automatically add Content-Type header for POST, PUT, or PATCH
        if [.POST, .PUT, .PATCH].contains(method), headers?["Content-Type"] == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Add headers
        if let token = getBearerToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Add body if provided
        if let body {
            do {
                // Serialize the body into JSON Data (whether it's an array or dictionary)
                let jsonData: Data
                if let arrayBody = body as? [Any] {
                    jsonData = try JSONSerialization.data(withJSONObject: arrayBody, options: [])
                } else if let dictBody = body as? [String: Any] {
                    jsonData = try JSONSerialization.data(withJSONObject: dictBody, options: [])
                } else {
                    // Handle other types of bodies, or pass as is
                    throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid body type."])
                }
                
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        // Execute request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response type."])))
                return
            }
            
            // Check the HTTP status code
            switch httpResponse.statusCode {
            case 200...299: // Success range
                do {
                    let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            case 400...499: // Client errors (e.g., bad request, unauthorized)
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Client error occurred."])))
            case 500...599: // Server errors
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error occurred."])))
            default: // Other status codes
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected response code."])))
            }
        }.resume()
    }
    
    /// Retrieve JWT token from secure storage
    private func getBearerToken() -> String? {
        return "ABC"
        //        return KeychainManager.shared.retrieveToken(for: tokenKey)
    }
}
