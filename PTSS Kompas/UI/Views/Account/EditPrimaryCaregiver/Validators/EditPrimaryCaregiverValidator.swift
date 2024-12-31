//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct EditPrimaryCaregiverValidator {
    func validate (_ body: PrimaryCaregiverAssign) throws {
        if body.userId.isEmpty {
            throw CreateValidatorError.missingUser
        }
    }
}

extension EditPrimaryCaregiverValidator {
    enum CreateValidatorError: LocalizedError {
        case missingUser
    }
}

extension EditPrimaryCaregiverValidator.CreateValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingUser:
            return "Vergeet niet om een andere gebruiker te selecteren"
        }
    }
}
