//
//  PasswordForgotRequestView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 01/01/2025.
//

import SwiftUI

struct PasswordForgotResetView: View {
    @ObservedObject var passwordForgotStore: PasswordForgotStore
    @StateObject var viewModel = PasswordForgotResetViewModel()
    @Environment(\.dismiss) private var dismiss // To navigate back

    
    var body: some View {
        Text("Wachtwoord vergeten") .font(.largeTitle)
            .foregroundColor(.dark)
        Text("Maak jouw nieuwe wachtwoord aan")
            .font(.subheadline)
            .foregroundColor(.dark)
            .padding(.bottom, 10).multilineTextAlignment(.center)
        Form {
            Section
            {
                VStack(alignment: .leading) {
                    Text("Wachtwoord")
                    SecureField(
                        "...",
                        text: $passwordForgotStore.password
                    )
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.dark, lineWidth: 2)
                    )
                }
                VStack(alignment: .leading) {
                    Text("Herhaal wachtwoord")
                    SecureField(
                        "...",
                        text: $passwordForgotStore.repeatPassword
                    )
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.dark, lineWidth: 2)
                    )
                }
            } footer: {
                if case .validation(let err) = viewModel.error,
                   let errorDesc = err.errorDescription {
                    Text(errorDesc)
                        .foregroundStyle(.red)
                }
            }
        }.padding(0)
            .background(.clear)
            .scrollContentBackground(.hidden)
        
        PasswordValidatorView(password: passwordForgotStore.password)
        
        ButtonVariant(label: "Reset wachtwoord", disabled: passwordForgotStore.email.isEmpty) {
            Task {
                await viewModel.resetPassword(body: ForgotPasswordReset(resetCode: passwordForgotStore.code, newPassword: passwordForgotStore.password, repeatNewPassword: passwordForgotStore.repeatPassword)) {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    PasswordForgotVerifyView(passwordForgotStore: PasswordForgotStore())
}
