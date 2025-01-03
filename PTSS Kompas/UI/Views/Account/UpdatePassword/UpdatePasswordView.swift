//
//  CreateContactQuestionView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import SwiftUI

struct UpdatePasswordView: View {
    @StateObject var viewModel = UpdatePasswordViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let onSuccess: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(height: 0)
                Button("Sluiten") {
                    dismiss()
                }
            }
            VStack(alignment: .leading) {
                Text("Wijzig wachtwoord") .font(.headline)
                    .foregroundColor(.dark)
                Spacer().frame(maxWidth: .infinity, maxHeight: 0)
            }
            
            Form {
                Section
                {
                    VStack(alignment: .leading) {
                        Text("Huidige wachtwoord")
                        SecureField(
                            "...",
                            text: $viewModel.currentPassword
                        )
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.dark, lineWidth: 2)
                        )
                    }
                    VStack(alignment: .leading) {
                        Text("Nieuw wachtwoord")
                        SecureField(
                            "...",
                            text: $viewModel.newPassword
                        )
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.dark, lineWidth: 2)
                        )
                    }
                    VStack(alignment: .leading) {
                        Text("Herhaal nieuw wachtwoord")
                        SecureField(
                            "...",
                            text: $viewModel.repeatNewPassword
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
                .alert(isPresented: $viewModel.isAlertFailure, error: viewModel.error) { }
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
            PasswordValidatorView(password: viewModel.newPassword)
            
            HStack {
                ButtonVariant(label: "Opslaan") {
                    Task {
                        await viewModel.updatePassword() {
                            onSuccess()
                            dismiss()
                        }
                    }
                }
            }
        }.padding()
    }
}
