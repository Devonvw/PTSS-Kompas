//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct InviteMemberValidator {
    func validate (_ userInviteCreate: UserInviteCreate) throws {

        if userInviteCreate.email.isEmpty {
            throw CreateValidatorError.missingEmail
        }
        
        if isValidEmail(userInviteCreate.email) == false {
            throw CreateValidatorError.invalidEmail
        }
    }
}

extension InviteMemberValidator {
    enum CreateValidatorError: LocalizedError {
        case missingEmail
        case invalidEmail
    }
}

extension InviteMemberValidator.CreateValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingEmail:
            return "Vergeet niet om een e-mail in te vullen"
        case .invalidEmail:
            return "Dit is geen correcte e-mail"
        }
    }
}
