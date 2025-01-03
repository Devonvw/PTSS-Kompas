//
//  PasswordValidatorView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 31/12/2024.
//

import SwiftUI

struct PasswordValidatorView: View {
    let password: String
    @State private var passwordValidateResult: PasswordValidationResult = .initial
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(maxWidth: .infinity, maxHeight: 0)
            HStack(alignment: .center) {
                Image(systemName: passwordValidateResult.isLengthValid ? "checkmark.circle" : "xmark.circle")
                Text("Minimaal 9 karakters")
            }
            HStack(alignment: .center) {
                Image(systemName: passwordValidateResult.hasNumber ? "checkmark.circle" : "xmark.circle")
                Text("Minimaal 1 cijfer")
            }
            HStack(alignment: .center) {
                Image(systemName: passwordValidateResult.hasUppercase ? "checkmark.circle" : "xmark.circle")
                Text("Minimaal 1 hoofdletter")
            }
            HStack(alignment: .center) {
                Image(systemName: passwordValidateResult.hasLowercase ? "checkmark.circle" : "xmark.circle")
                Text("Minimaal 1 kleine letter")
            }
            HStack(alignment: .center) {
                Image(systemName: passwordValidateResult.hasSpecialCharacter ? "checkmark.circle" : "xmark.circle")
                Text("Minimaal 1 speciaal karakter")
            }
        }.onChange(of: password) { oldPassword, newPassword in
            passwordValidateResult = PasswordValidator.validate(password: newPassword)
        }.onAppear {
            passwordValidateResult = PasswordValidator.validate(password: password)
        }
    }
}

#Preview {
    PasswordValidatorView(password: "Password")
}
