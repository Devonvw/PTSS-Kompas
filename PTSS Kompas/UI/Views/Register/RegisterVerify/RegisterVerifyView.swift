//
//  RegisterVerifyView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 10/12/2024.
//

import SwiftUI

struct RegisterVerifyView: View {
    @ObservedObject var registerViewModel: RegisterViewModel
    
    var body: some View {
        Form {
            Section
            {
                VStack(alignment: .leading) {
                    Text("Email")
                    TextField(
                        "voorbeeld@gmail.com",
                        text: $registerViewModel.email,
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
                    TextField(
                        "..",
                        text: $registerViewModel.registerCode,
                        axis: .vertical
                    )
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.dark, lineWidth: 2)
                    )
                }
                
            } footer: {
//                if case .validation(let err) = viewModel.error,
//                   let errorDesc = err.errorDescription {
//                    Text(errorDesc)
//                        .foregroundStyle(.red)
//                }
            }
        }.padding(0)
            .background(.clear)
            .scrollContentBackground(.hidden)
        
        
        ButtonVariant(label: "Ga verder", disabled: true) {}
        Text("Heb je geen 6-cijferige code ontvangen? Neem dan contact op met de persoon die jou heeft uitgenodigd.").multilineTextAlignment(.center).padding(.bottom, 10).font(.caption).foregroundColor(.dark.opacity(0.8))
        Text("Heb je al een account").multilineTextAlignment(.center).font(.caption).foregroundColor(.dark.opacity(0.8))
        ButtonVariant(label: "Inloggen met email", variant: .light) {}
    }
}

#Preview {
    RegisterVerifyView(registerViewModel: RegisterViewModel())
}
