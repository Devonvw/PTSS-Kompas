//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct RegisterVerifyValidator {
    func validate(_ userInviteVerify: UserInviteVerify) throws {
        if userInviteVerify.email.isEmpty {
            throw ValidatorError.missingEmail
        }
        
        if isValidEmail(userInviteVerify.email) == false {
            throw ValidatorError.invalidEmail
        }
        
        if userInviteVerify.invitationCode.isEmpty {
            throw ValidatorError.missingCode
        }
        
        if userInviteVerify.invitationCode.count != 6 {
            throw ValidatorError.invalidCode
        }
        
        if !userInviteVerify.invitationCode.allSatisfy({ $0.isNumber }) {
            throw ValidatorError.invalidCodeFormat
        }
    }
}

extension RegisterVerifyValidator {
    enum ValidatorError: LocalizedError {
        case missingEmail
        case invalidEmail
        case missingCode
        case invalidCode
        case invalidCodeFormat
    }
}

extension RegisterVerifyValidator.ValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingEmail:
            return "Vergeet niet jouw e-mail in te vullen"
        case .invalidEmail:
            return "Dit is geen correcte e-mail"
        case .invalidCode:
            return "De code moet uit 6 karakters bestaan"
        case .missingCode:
            return "Vergeet niet om jouw code in te vullen"
        case .invalidCodeFormat:
            return "De code mag alleen uit nummers bestaan"
        }
    }
}
