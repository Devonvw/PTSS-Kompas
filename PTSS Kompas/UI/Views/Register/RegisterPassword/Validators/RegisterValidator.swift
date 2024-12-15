//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct RegisterValidator {
    func validate (_ userRegister: UserRegister) throws {
        if userRegister.firstName.isEmpty {
            throw ValidatorError.missingFirstName
        }
        
        if userRegister.lastName.isEmpty {
            throw ValidatorError.missingLastName
        }
        
        if userRegister.password.isEmpty {
            throw ValidatorError.missingPassword
        }
        
        if userRegister.repeatPassword.isEmpty {
            throw ValidatorError.missingRepeatPassword
        }
        
        if userRegister.password != userRegister.repeatPassword {
            throw ValidatorError.invalidPassword
        }
    }
}

extension RegisterValidator {
    enum ValidatorError: LocalizedError {
        case missingFirstName
        case missingLastName
        case missingPassword
        case missingRepeatPassword
        case invalidPassword
    }
}

extension RegisterValidator.ValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingFirstName:
            return "Vergeet niet jouw voornaam in te vullen"
        case .missingLastName:
            return "Vergeet niet jouw achternaam in te vullen"
        case .missingPassword:
            return "Vergeet niet om een wachtwoord in te vullen"
        case .missingRepeatPassword:
            return "Vergeet niet om het wachtwoord te herhalen"
        case .invalidPassword:
            return "Wachtwoord en herhaal wachtwoord zijn niet gelijk"
        }
    }
}
