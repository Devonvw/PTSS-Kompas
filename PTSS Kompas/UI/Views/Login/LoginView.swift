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
        NavigationStack {
            VStack {
                Image("LogoFull")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                
                Text("Welkom") .font(.largeTitle)
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
                        }.padding(.bottom, 12)
                        NavigationLink(destination: PasswordForgotView()) {
                            Text("Wachtwoord vergeten?")
                        }.buttonStyle(PlainButtonStyle())
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
                Spacer().frame(maxHeight: .infinity)
                Text("Wachtwoord toch gevonden?")
                NavigationLink(destination: RegisterView()) {
                    ButtonVariant(label: "Heb je nog geen account? \nKlik dan op de registreren knop hieronder. Hierna is het mogelijk om te registreren met een email en de ontvangen code.", variant: .light) {
                        
                    }.disabled(true)
                }
            }.padding()
        }
    }
}

#Preview {
    LoginView()
}
