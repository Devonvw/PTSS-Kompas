//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct PasswordForgetResetValidator {
    func validate(_ forgotPasswordReset: ForgotPasswordReset) throws {
        if forgotPasswordReset.resetCode.isEmpty {
            throw ValidatorError.missingCode
        }
        
        if forgotPasswordReset.resetCode.count != 6 {
            throw ValidatorError.invalidCode
        }
        
        if !forgotPasswordReset.resetCode.allSatisfy({ $0.isNumber }) {
            throw ValidatorError.invalidCodeFormat
        }
        
        if forgotPasswordReset.newPassword.isEmpty {
            throw ValidatorError.missingPassword
        }
        
        if forgotPasswordReset.repeatNewPassword.isEmpty {
            throw ValidatorError.missingRepeatPassword
        }
        
        if !PasswordValidator.validate(password: forgotPasswordReset.newPassword).isValid {
            throw ValidatorError.invalidPassword
        }
        
        if forgotPasswordReset.newPassword != forgotPasswordReset.repeatNewPassword {
            throw ValidatorError.invalidRepeatPassword
        }
    }
}

extension PasswordForgetResetValidator {
    enum ValidatorError: LocalizedError {
        case missingCode
        case invalidCode
        case invalidCodeFormat
        case missingPassword
        case missingRepeatPassword
        case invalidPassword
        case invalidRepeatPassword
    }
}

extension PasswordForgetResetValidator.ValidatorError {
    var errorDescription: String? {
        switch self {
        case .invalidCode:
            return "De code moet uit 6 karakters bestaan"
        case .missingCode:
            return "Vergeet niet om jouw code in te vullen"
        case .invalidCodeFormat:
            return "De code mag alleen uit nummers bestaan"
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
