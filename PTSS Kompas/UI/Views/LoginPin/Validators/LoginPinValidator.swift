//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct LoginPinValidator {
    static let pinRegex = "^[0-9]{4}$"

    func validate (_ loginPin: PinLogin) throws {
        if loginPin.pin.isEmpty {
            throw ValidatorError.missingPin
        }
        
        if loginPin.pin.count != 4 {
            throw ValidatorError.invalidPin
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", LoginPinValidator.pinRegex).evaluate(with: loginPin.pin) {
            throw ValidatorError.invalidPin
        }
    }
}

extension LoginPinValidator {
    enum ValidatorError: LocalizedError {
        case missingPin
        case invalidPin
    }
}

extension LoginPinValidator.ValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingPin:
            return "Vergeet niet jouw pincode in te vullen"
        case .invalidPin:
            return "De pincode moet uit 4 cijfers bestaan"
        }
    }
}
