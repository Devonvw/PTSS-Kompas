//
//  Grouo.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct UserGroup: Codable, Identifiable, ExampleProvidable {
    let id: String
    let patientId: String
    let HCPId: String
    let primaryCaregiverId: String
    let createdAt: String

    static let example: UserGroup = .init(
        id: "987fcdeb-51a2-12d3-a456-426614174000",
        patientId: "123e4567-e89b-12d3-a456-426614174000",
        HCPId: "123e4567-e89b-12d3-a456-426614174001",
        primaryCaregiverId: "123e4567-e89b-12d3-a456-426614174002",
        createdAt: "2024-12-04T14:30:00Z"
    )
}
