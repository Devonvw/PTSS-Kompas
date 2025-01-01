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
    
    
    var body: some View {
        Text("Wachtwoord vergeten") .font(.largeTitle)
            .foregroundColor(.dark)
        Text("Vul je emailadres in van jouw account en wij sturen jou een email met een code om een nieuw wachtwoord aan te maken.")
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
            .scrollContentBackground(.hidden)
        
        ButtonVariant(label: "Verstuur email", disabled: passwordForgotStore.email.isEmpty) {
            Task {
                await viewModel.request(body: ForgotPassword(email: passwordForgotStore.email)) {
                    passwordForgotStore.currentScreen = .Verify
                }
            }
        }
    }
}

#Preview {
    PasswordForgotVerifyView(passwordForgotStore: PasswordForgotStore())
}
