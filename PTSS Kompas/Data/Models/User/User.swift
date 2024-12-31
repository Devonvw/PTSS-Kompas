//
//  User.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct User: Codable, Identifiable, Hashable, ExampleProvidable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let role: Role
    let groupId: String
    let lastSeen: String
    
    static let example: User = .init(
        id: "1",
        email: "bert@example.com",
        firstName: "Bert",
        lastName: "Smit",
        role: Role.Patient,
        groupId: "1",
        lastSeen: "2024-11-22T11:10:10Z"
    )
}
