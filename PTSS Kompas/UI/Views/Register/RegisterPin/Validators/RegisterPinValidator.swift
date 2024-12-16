//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct RegisterPinValidator {
    static let pinRegex = "^[0-9]{4}$"

    func validate (_ pinCreate: PinCreate) throws {
        if pinCreate.pin.isEmpty {
            throw ValidatorError.missingPin
        }
        
        if pinCreate.pin.count != 4 {
            throw ValidatorError.invalidPinLength
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", RegisterPinValidator.pinRegex).evaluate(with: pinCreate.pin) {
            throw ValidatorError.invalidPin
        }
    }
}

extension RegisterPinValidator {
    enum ValidatorError: LocalizedError {
        case missingPin
        case invalidPinLength
        case invalidPin
    }
}

extension RegisterPinValidator.ValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingPin:
            return "Vergeet niet een pincode in te vullen"
        case .invalidPinLength:
            return "De pincode moeet uit 4 cijfers bestaan"
        case .invalidPin:
            return "De pincode mag alleen uit cijfers bestaan"
        }
    }
}
