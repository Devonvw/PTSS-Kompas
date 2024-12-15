//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct RegisterNameValidator {
    func validate (firstName: String, lastName: String) throws {
        if firstName.isEmpty {
            throw ValidatorError.missingFirstName
        }
        
        if lastName.isEmpty {
            throw ValidatorError.missingLastName
        }
    }
}

extension RegisterNameValidator {
    enum ValidatorError: LocalizedError {
        case missingFirstName
        case missingLastName
    }
}

extension RegisterNameValidator.ValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingFirstName:
            return "Vergeet niet jouw voornaam in te vullen"
        case .missingLastName:
            return "Vergeet niet jouw achternaam in te vullen"
        }
    }
}
