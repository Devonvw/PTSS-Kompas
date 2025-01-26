//
//  PasswordValidatore.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 15/12/2024.
//

struct PasswordValidationResult {
    let isLengthValid: Bool
    let hasNumber: Bool
    let hasUppercase: Bool
    let hasLowercase: Bool
    let hasSpecialCharacter: Bool

    var isValid: Bool {
        return isLengthValid && hasNumber && hasUppercase && hasLowercase && hasSpecialCharacter
    }
    
    static let initial: PasswordValidationResult = .init(isLengthValid: false, hasNumber: false, hasUppercase: false, hasLowercase: false, hasSpecialCharacter: false)
}


struct PasswordValidator {
    static func validate(password: String) -> PasswordValidationResult {
        let isLengthValid = password.count >= 9
        let hasNumber = password.range(of: "\\d", options: .regularExpression) != nil
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasSpecialCharacter = password.range(of: "[^a-zA-Z0-9]", options: .regularExpression) != nil
        
        return PasswordValidationResult(
                isLengthValid: isLengthValid,
                hasNumber: hasNumber,
                hasUppercase: hasUppercase,
                hasLowercase: hasLowercase,
                hasSpecialCharacter: hasSpecialCharacter
            )
    }
}
