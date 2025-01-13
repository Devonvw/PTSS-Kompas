//
//  AuthService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 16/12/2024.
//
import Foundation

final class AuthService {
    let baseURL = "auth/"
    
    func logout() async throws -> Void {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "logout",
            method: .POST,
            responseType: VoidResponse.self
        )
    }
}

