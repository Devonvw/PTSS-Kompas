//
//  URLParameters.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 04/12/2024.
//

import Foundation

extension URL {
    func appendingQueryParameters(_ parameters: [String: String?]) -> URL? {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        let queryItems = parameters.compactMap { key, value -> URLQueryItem? in
            guard let value = value else { return nil }
            return URLQueryItem(name: key, value: value)
        }
        
        components.queryItems = (components.queryItems ?? []) + queryItems
        
        return components.url
    }
}
