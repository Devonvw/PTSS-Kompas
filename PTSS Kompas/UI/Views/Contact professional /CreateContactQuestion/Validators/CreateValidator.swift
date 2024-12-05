//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct CreateContactQuestionValidator {
    func validate (_ contactQuestion: CreateContactQuestion) throws {
        if contactQuestion.subject.isEmpty {
            throw CreateValidatorError.missingSubject
        }
        
        if contactQuestion.content.isEmpty {
            throw CreateValidatorError.missingContent
        }
    }
}

extension CreateContactQuestionValidator {
    enum CreateValidatorError: LocalizedError {
        case missingSubject
        case missingContent
    }
}

extension CreateContactQuestionValidator.CreateValidatorError {
    var errorDescription: String? {
        switch self {
            case .missingSubject:
            return "Vergeet niet om een onderwerp in te vullen"
        case .missingContent:
            return "Vergeet niet om een beschrijving in te vullen"
        }
    }
}
