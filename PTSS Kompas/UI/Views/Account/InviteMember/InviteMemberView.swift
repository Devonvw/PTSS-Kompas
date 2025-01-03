//
//  CreateContactQuestionView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import SwiftUI

struct InviteMemberView: View {
    @StateObject var viewModel = InviteMemberViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let onSuccess: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(height: 0)
                Button("Sluiten") {
                    dismiss()
                }.padding()
            }
            VStack(alignment: .leading) {
                Text("Verstuur een uitnoding") .font(.headline)
                    .foregroundColor(.dark)
                Spacer().frame(maxWidth: .infinity, maxHeight: 0)
            }.padding()
            
            Form {
                Section
                {
                    VStack(alignment: .leading) {
                        Text("Email")
                        TextField(
                            "voorbeeld@gmail.com",
                            text: $viewModel.newMemberEmail,
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
                .alert(isPresented: $viewModel.isAlertFailure, error: viewModel.error) { }
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
            
            HStack {
                ButtonVariant(label: "Verstuur uitnodiging") {
                    Task {
                        await viewModel.inviteMember() {
                            onSuccess()
                            dismiss()
                        }
                    }
                }
            }.padding()
        }
    }
}
