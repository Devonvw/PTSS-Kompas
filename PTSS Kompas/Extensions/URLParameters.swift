//
//  URLParameters.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 04/12/2024.
//

import Foundation

extension URL {
    /// Adds query parameters to the URL, omitting parameters with `nil` values.
    /// - Parameter parameters: A dictionary of query parameter key-value pairs.
    /// - Returns: A new `URL` with the specified query parameters added, or `nil` if the URL is invalid.
    func appendingQueryParameters(_ parameters: [String: String?]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        // Filter out parameters with nil values and add the rest as query items
        let queryItems = parameters.compactMap { key, value -> URLQueryItem? in
            guard let value = value else { return nil } // Exclude `nil` values
            return URLQueryItem(name: key, value: value)
        }
        
        // Append filtered query items
        components.queryItems = (components.queryItems ?? []) + queryItems
        
        return components.url
    }
}
