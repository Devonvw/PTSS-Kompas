//
//  PasswordForgotRequestView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 01/01/2025.
//

import SwiftUI

struct PasswordForgotVerifyView: View {
    @ObservedObject var passwordForgotStore: PasswordForgotStore
    @StateObject var viewModel = PasswordForgotVerifyViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("Wachtwoord vergeten") .font(.largeTitle)
            .foregroundColor(.dark)
        Text("Er is een 6-cijferige code verstuurd naar \(passwordForgotStore.email).")
            .font(.subheadline)
            .foregroundColor(.dark)
            .padding(.bottom, 10).multilineTextAlignment(.center)
        Form {
            Section
            {
                VStack(alignment: .leading) {
                    Text("Code")
                    OTPField(numberOfFields: 6, otp: $passwordForgotStore.code)
                        .previewLayout(.sizeThatFits)
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
            .scrollContentBackground(.hidden).frame(height: 150)
        
        ButtonVariant(label: "Ga verder", disabled: passwordForgotStore.email.isEmpty, isLoading: viewModel.isLoading) {
            Task {
                await viewModel.request(body: ForgotPasswordVerify(email: passwordForgotStore.email, resetCode: passwordForgotStore.code)) {
                    passwordForgotStore.currentScreen = .Reset
                }
            }
        }
        Spacer().frame(maxHeight: .infinity)
        Text("Wachtwoord toch gevonden?")
        ButtonVariant(label: "Inloggen", variant: .light) {
            dismiss()
        }
    }
}

#Preview {
    PasswordForgotVerifyView(passwordForgotStore: PasswordForgotStore())
}
