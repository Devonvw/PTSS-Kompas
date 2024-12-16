//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct LoginValidator {
    func validate (_ login: Login) throws {
        if login.email.isEmpty {
            throw ValidatorError.missingEmail
        }
        
        if isValidEmail(login.email) == false {
            throw ValidatorError.invalidEmail
        }
        
        if login.password.isEmpty {
            throw ValidatorError.missingPassword
        }
    }
}

extension LoginValidator {
    enum ValidatorError: LocalizedError {
        case missingEmail
        case invalidEmail
        case missingPassword
    }
}

extension LoginValidator.ValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingEmail:
            return "Vergeet niet jouw e-mail in te vullen"
        case .invalidEmail:
            return "Dit is geen correcte e-mail"
        case .missingPassword:
            return "Vergeet niet om jouw wachtwoord in te vullen"
        }
    }
}
