//
//  LoginView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 19/11/2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        Text("Inloggen") .font(.largeTitle)
            .foregroundColor(.dark)
        Form {
            Section
            {
                VStack(alignment: .leading) {
                    Text("Email")
                    TextField(
                        "voorbeeld@gmail.com",
                        text: $viewModel.email,
                        axis: .vertical
                    )
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.dark, lineWidth: 2)
                    )
                }
                VStack(alignment: .leading) {
                    Text("Wachtwoord")
                    SecureField(
                        "...",
                        text: $viewModel.password
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
        
        ButtonVariant(label: "Login") {
            Task {
                await viewModel.login {
//                    registerStore.currentScreen = .Name
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
