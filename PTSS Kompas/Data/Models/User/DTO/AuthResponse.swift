//
//  AuthResponse.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct AuthResponse: Codable, ExampleProvidable {
    let accessToken: String
    let refreshToken: String

    static let example: AuthResponse = .init(
        accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c",
        refreshToken: "dGhpcyBpcyBhIHNhbXBsZSByZWZyZXNoIHRva2VuIHZhbHVlIHdpdGggYSBsb25nZXIgZXhwaXJhdGlvbiB0aW1l"
    )
}
