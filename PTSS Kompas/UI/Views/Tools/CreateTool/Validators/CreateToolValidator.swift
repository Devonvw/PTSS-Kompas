//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct CreateToolValidator {
    func validate (_ createTool: CreateTool) throws {
        if createTool.name.isEmpty {
            throw CreateValidatorError.missingName
        }
        
        if createTool.description.isEmpty {
            throw CreateValidatorError.missingDescription
        }
    }
}

extension CreateToolValidator {
    enum CreateValidatorError: LocalizedError {
        case missingName
        case missingDescription
    }
}

extension CreateToolValidator.CreateValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingName:
            return "Vergeet niet om het hulpmiddel een naam te geven"
        case .missingDescription:
            return "Vergeet niet om het hulpmiddel een beschrijving te geven"
        }
    }
}
