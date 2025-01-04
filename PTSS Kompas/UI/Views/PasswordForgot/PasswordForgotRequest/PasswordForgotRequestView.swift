//
//  PasswordForgotRequestView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 01/01/2025.
//

import SwiftUI

struct PasswordForgotRequestView: View {
    @ObservedObject var passwordForgotStore: PasswordForgotStore
    @StateObject var viewModel = PasswordForgotRequestViewModel()
    @Environment(\.dismiss) private var dismiss
    
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
                    Text("Email")
                    TextField(
                        "voorbeeld@gmail.com",
                        text: $passwordForgotStore.email,
                        axis: .vertical
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

        ButtonVariant(label: "Verstuur email", disabled: passwordForgotStore.email.isEmpty) {
            Task {
                await viewModel.request(body: ForgotPassword(email: passwordForgotStore.email)) {
                    passwordForgotStore.currentScreen = .Verify
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
    PasswordForgotRequestView(passwordForgotStore: PasswordForgotStore())
}
