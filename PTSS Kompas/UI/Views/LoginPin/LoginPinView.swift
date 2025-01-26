//
//  LoginView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 19/11/2024.
//

import SwiftUI

struct LoginPinView: View {
    @StateObject var viewModel = LoginPinViewModel()
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("LogoFull")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                
                Text("Welkom \(authManager.user?.firstName ?? "")") .font(.largeTitle)
                    .foregroundColor(.dark)
                Form {
                    Section
                    {
                        HStack {
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Pincode")
                                OTPField(numberOfFields: 4, otp: $viewModel.pin)
                                    .previewLayout(.sizeThatFits)
                            }
                            Spacer()
                        }.padding(.bottom, 12)
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
                
                ButtonVariant(label: "Login", isLoading: viewModel.isLoading) {
                    Task {
                        await viewModel.loginPin {
                        }
                    }
                }.padding(.bottom, 10)
                Text("Pincode vergeten? Log dan in met jouw emailadres. Vervolgens is het bij instellingen mogelijk om de pincode te wijzigen.").multilineTextAlignment(.center)
                NavigationLink(destination: LoginView()) {
                    ButtonVariant(label: "Inloggen met email", variant: .light) {
                        
                    }.disabled(true)
                }
            }.padding().alert(isPresented: $viewModel.isAlertFailure, error: viewModel.error) { }
        }
    }
}

#Preview {
    LoginView()
}
