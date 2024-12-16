//
//  RegisterPinView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 16/12/2024.
//

import SwiftUI

struct RegisterPinView: View {
    @StateObject var viewModel = RegisterPinViewModel()

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
        
        ButtonVariant(label: "Ga verder") {
            Task {
                await viewModel.createPin {
                }

            }
        }
        Text("Heb je geen 6-cijferige code ontvangen? Neem dan contact op met de persoon die jou heeft uitgenodigd.").multilineTextAlignment(.center).padding(.bottom, 10).font(.caption).foregroundColor(.dark.opacity(0.8))
        Text("Heb je al een account?").multilineTextAlignment(.center).font(.caption).foregroundColor(.dark.opacity(0.8))
//        ButtonVariant(label: "Inloggen met email", variant: .light) {}
    }
}

#Preview {
    RegisterPinView()
}
