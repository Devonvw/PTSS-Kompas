//
//  LoginView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 19/11/2024.
//

import SwiftUI

struct LoginPinView: View {
    @StateObject var viewModel = LoginPinViewModel()

    var body: some View {
        Text("Inloggen") .font(.largeTitle)
            .foregroundColor(.dark)
        Form {
            Section
            {
                VStack(alignment: .leading) {
                    Text("Pincode")
                    OTPField(numberOfFields: 4, otp: $viewModel.pin)
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
        
        ButtonVariant(label: "Login") {
            Task {
                await viewModel.loginPin {
//                    registerStore.currentScreen = .Name
                }
            }
        }
        
       
        Text("Pincode vergeten? Log dan in met jouw emailadres. Vervolgens is het bij instellingen mogelijk om de pincode te wijzigen.").multilineTextAlignment(.center).font(.caption).foregroundColor(.dark.opacity(0.8))
        ButtonVariant(label: "Inloggen met email") {
            
        }.disabled(true)
    }
}

#Preview {
    LoginView()
}
