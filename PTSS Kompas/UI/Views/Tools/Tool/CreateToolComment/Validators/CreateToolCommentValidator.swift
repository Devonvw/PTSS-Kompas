//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct CreateToolCommentValidator {
    func validate (_ toolComment: CreateToolComment) throws {

        if toolComment.content.isEmpty {
            throw CreateValidatorError.missingContent
        }
    }
}

extension CreateToolCommentValidator {
    enum CreateValidatorError: LocalizedError {
        case missingContent
    }
}

extension CreateToolCommentValidator.CreateValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingContent:
            return "Vergeet niet om een opmerking in te vullen"
        }
    }
}
