//
//  ResponseError.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

struct ResponseError: Codable {
    let code: String
    let message: String
    
    var localizedDescription: String {
        return message
    }
}
