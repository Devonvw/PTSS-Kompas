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
        responseType: T.Type,
        completion: @escaping (Result<T, NSError>) -> Void
    ) {
        guard var url = URL(string: endpoint, relativeTo: baseURL) else {
            completion(.failure(genericError))
            return
        }
        
        if let parameters {
            guard let appendedURL = url.appendingQueryParameters(parameters) else {
                completion(.failure(genericError))
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
                } else {
                    completion(.failure(genericError))
                    return
                }
                
                request.httpBody = jsonData
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            catch {
                completion(.failure(genericError))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                completion(.failure(self.genericError))
                return
            }
            
            guard let data = data else {
                completion(.failure(self.genericError)) //???
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(self.genericError))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(self.genericError))
                }
            case 400...499:
                do {
                    let errorResponse = try JSONDecoder().decode(ResponseError.self, from: data)
                    let localizedError = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorResponse.localizedDescription])
                    completion(.failure(localizedError))
                } catch {
                    completion(.failure(self.genericError))
                }
            case 500...599:
                completion(.failure(self.genericError))
            default:
                completion(.failure(self.genericError))
            }
            
        }.resume()
    }
    
    private func getBearerToken() -> String? {
        return "ABC"
        //        return KeychainManager.shared.retrieveToken(for: tokenKey)
    }
}
