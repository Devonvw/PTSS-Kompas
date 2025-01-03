//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct PasswordForgetVerifyValidator {
    func validate(_ forgotPasswordVerify: ForgotPasswordVerify) throws {
        if forgotPasswordVerify.resetCode.isEmpty {
            throw ValidatorError.missingCode
        }
        
        if forgotPasswordVerify.resetCode.count != 6 {
            throw ValidatorError.invalidCode
        }
        
        if !forgotPasswordVerify.resetCode.allSatisfy({ $0.isNumber }) {
            throw ValidatorError.invalidCodeFormat
        }
    }
}

extension PasswordForgetVerifyValidator {
    enum ValidatorError: LocalizedError {
        case missingCode
        case invalidCode
        case invalidCodeFormat
    }
}

extension PasswordForgetVerifyValidator.ValidatorError {
    var errorDescription: String? {
        switch self {
        case .invalidCode:
            return "De code moet uit 6 karakters bestaan"
        case .missingCode:
            return "Vergeet niet om jouw code in te vullen"
        case .invalidCodeFormat:
            return "De code mag alleen uit nummers bestaan"
        }
    }
}
