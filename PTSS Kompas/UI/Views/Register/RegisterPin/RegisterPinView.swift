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
        Text("Maak een pincode aan om sneller in te kunnen loggen. Dit is optioneel.")
            .font(.subheadline)
            .foregroundColor(.dark)
            .padding(.bottom, 10).multilineTextAlignment(.center)
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
        
        ButtonVariant(label: "Start") {
            Task {
                await viewModel.createPin {
                }
            }
        }
        ButtonVariant(label: "Overslaan", variant: .light) {
            AuthManager.shared.setLoggedIn()
        }
    }
}

#Preview {
    RegisterPinView()
}
