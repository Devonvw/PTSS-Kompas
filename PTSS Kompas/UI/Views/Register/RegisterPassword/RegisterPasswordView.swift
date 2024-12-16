//
//  RegisterPasswordView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 15/12/2024.
//

import SwiftUI

struct RegisterPasswordView: View {
    @ObservedObject var registerStore: RegisterStore
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        Text("Welkom \(registerStore.firstName)")
            .font(.largeTitle)
            .foregroundColor(.dark)
        Text("Maak een wachtwoord aan en start met PTSS Kompas.")
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
                        text: $registerStore.password
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
                        text: $registerStore.repeatPassword
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
        
        
        HStack(alignment: .center) {
            ButtonVariant(label: "", iconRight: "arrow.left") {
                registerStore.currentScreen = .Name
            }.frame(width: 80).padding(.trailing, 10)
            ButtonVariant(label: "Verder", disabled: true) {
                Task {
                    await viewModel.register(body: UserRegister(firstName: registerStore.firstName, lastName: registerStore.lastName, password: registerStore.password, repeatPassword: registerStore.repeatPassword, invitationCode: registerStore.registerCode, email: registerStore.email)) {
                        registerStore.currentScreen = .Pin
                    }
                }
            }
        }
    }
}

#Preview {
    RegisterPasswordView(registerStore: RegisterStore())
}
