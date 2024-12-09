//
//  PrimaryCaregiverAssign.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct PrimaryCaregiverAssign: Codable, ExampleProvidable {
    let userId: String

    static let example: PrimaryCaregiverAssign = .init(
        userId: "123e4567-e89b-12d3-a456-426614174002"
    )
}
