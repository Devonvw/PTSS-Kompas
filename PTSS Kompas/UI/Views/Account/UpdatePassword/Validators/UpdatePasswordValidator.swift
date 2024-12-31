//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct UpdatePasswordValidator {

    func validate (_ passwordUpdate: PasswordUpdate) throws {

        if passwordUpdate.currentPassword.isEmpty {
            throw ValidatorError.missingCurrentPassword
        }
        
        if passwordUpdate.newPassword.isEmpty {
            throw ValidatorError.missingPassword
        }
        
        if passwordUpdate.repeatNewPassword.isEmpty {
            throw ValidatorError.missingRepeatPassword
        }
        
        if !PasswordValidator.validate(password: passwordUpdate.newPassword).isValid {
            throw ValidatorError.invalidPassword
        }
        
        if passwordUpdate.newPassword != passwordUpdate.repeatNewPassword {
            throw ValidatorError.invalidRepeatPassword
        }
        
        
    }
}

extension UpdatePasswordValidator {
    enum ValidatorError: LocalizedError {
        case missingCurrentPassword
        case missingPassword
        case missingRepeatPassword
        case invalidPassword
        case invalidRepeatPassword
    }
}

extension UpdatePasswordValidator.ValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingCurrentPassword:
            return "Vergeet niet het huidige wachtwoord in te vullen"
        case .missingPassword:
            return "Vergeet niet om een nieuw wachtwoord in te vullen"
        case .missingRepeatPassword:
            return "Vergeet niet om het nieuwe wachtwoord te herhalen"
        case .invalidPassword:
            return "Het nieuwe wachtwoord voldoet niet aan de gestelde eisen"
        case .invalidRepeatPassword:
            return "Het nieuwe wachtwoord en herhaal wachtwoord zijn niet gelijk"
        }
    }
}
