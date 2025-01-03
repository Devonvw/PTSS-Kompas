//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct UpdatePinValidator {
    static let pinRegex = "^[0-9]{4}$"

    func validate (_ pinUpdate: PinUpdate) throws {

        if !pinUpdate.currentPin.isEmpty && !NSPredicate(format: "SELF MATCHES %@", UpdatePinValidator.pinRegex).evaluate(with: pinUpdate.currentPin) {
            throw ValidatorError.invalidCurrentPin
        }
        
        if pinUpdate.newPin.isEmpty {
            throw ValidatorError.missingNewPin
        }
        
        if pinUpdate.newPin.count != 4 {
            throw ValidatorError.invalidNewPin
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", UpdatePinValidator.pinRegex).evaluate(with: pinUpdate.newPin) {
            throw ValidatorError.invalidNewPin
        }

    }
}

extension UpdatePinValidator {
    enum ValidatorError: LocalizedError {
        case missingNewPin
        case invalidCurrentPin
        case invalidNewPin
    }
}

extension UpdatePinValidator.ValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingNewPin:
            return "Vergeet niet om een nieuwe pincode in te vullen"
        case .invalidCurrentPin:
            return "De huidige pincode moet uit 4 cijfers bestaan"
        case .invalidNewPin:
            return "De nieuwe pincode moet uit 4 cijfers bestaan"
        }
    }
}
