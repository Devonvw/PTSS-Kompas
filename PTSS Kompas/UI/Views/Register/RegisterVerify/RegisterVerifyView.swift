//
//  RegisterVerifyView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 10/12/2024.
//

import SwiftUI

struct RegisterVerifyView: View {
    @ObservedObject var registerStore: RegisterStore
    @StateObject var viewModel = RegisterVerifyViewModel()
    
    
    var body: some View {
        Text("Welkom") .font(.largeTitle)
            .foregroundColor(.dark)
        Text("Vul je e-mailadres en de 6-cijferige code in die je per e-mail hebt ontvangen om te beginnen met PTSS Kompas.")
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
                        text: $registerStore.email,
                        axis: .vertical
                    )
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.dark, lineWidth: 2)
                    )
                }
                VStack(alignment: .leading) {
                    Text("Code")
                    OTPField(numberOfFields: 6, otp: $registerStore.registerCode)
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
        
        ButtonVariant(label: "Ga verder", disabled: registerStore.email.isEmpty || registerStore.registerCode.count != 6) {
            Task {
                await viewModel.verifyRegister(body: UserInviteVerify(email: registerStore.email, invitationCode: registerStore.registerCode)) {
                    registerStore.currentScreen = .Name
                }
            }
        }
        Text("Heb je geen 6-cijferige code ontvangen? Neem dan contact op met de persoon die jou heeft uitgenodigd.").multilineTextAlignment(.center).padding(.bottom, 10).font(.caption).foregroundColor(.dark.opacity(0.8))
        Text("Heb je al een account?").multilineTextAlignment(.center).font(.caption).foregroundColor(.dark.opacity(0.8))
//        ButtonVariant(label: "Inloggen met email", variant: .light) {}
    }
}

#Preview {
    RegisterVerifyView(registerStore: RegisterStore())
}
