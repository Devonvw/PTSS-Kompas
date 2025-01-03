//
//  Role.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

enum Role: String, Codable, Hashable {
    case Patient = "patient"
    case PrimaryCaregiver = "primary_caregiver"
    case FamilyMember = "family_member"
    case HealthcareProfessional = "healthcare_professional"
    case Admin = "admin"
}
