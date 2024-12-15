//
//  RegisterNameView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 15/12/2024.
//

import SwiftUI

struct RegisterNameView: View {
    @ObservedObject var registerStore: RegisterStore
    @StateObject var viewModel = RegisterNameViewModel()

    var body: some View {
        Text("Welkom") .font(.largeTitle)
            .foregroundColor(.dark)
        Text("Vul hieronder je naam in om verder te gaan en deel te nemen.")
            .font(.subheadline)
            .foregroundColor(.dark)
            .padding(.bottom, 10).multilineTextAlignment(.center)
        Form {
            Section
            {
                VStack(alignment: .leading) {
                    Text("Voornaam")
                    TextField(
                        "Jan",
                        text: $registerStore.firstName,
                        axis: .vertical
                    )
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.dark, lineWidth: 2)
                    )
                }
                VStack(alignment: .leading) {
                    Text("Achternaam")
                    TextField(
                        "Jansen",
                        text: $registerStore.lastName,
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
        
        
        ButtonVariant(label: "Volgende", disabled: registerStore.lastName.isEmpty || registerStore.firstName.isEmpty) {
            Task {
                await viewModel.validateName(firstName: registerStore.firstName, lastName: registerStore.lastName) {
                    registerStore.currentScreen = .Password
                }
            }
        }
    }
}

#Preview {
    RegisterNameView(registerStore: RegisterStore())
}
