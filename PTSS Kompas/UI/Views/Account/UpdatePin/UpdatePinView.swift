//
//  CreateContactQuestionView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import SwiftUI

struct UpdatePinView: View {
    @StateObject var viewModel = UpdatePinViewModel()
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
                Text("Wijzig pincode") .font(.headline)
                    .foregroundColor(.dark)
                Spacer().frame(maxWidth: .infinity, maxHeight: 0)
            }.padding()
            
            Form {
                Section
                {
                    VStack(alignment: .leading) {
                        Text("Huidige pincode")
                        OTPField(numberOfFields: 4, otp: $viewModel.currentPin)
                            .previewLayout(.sizeThatFits)
                    }
                    VStack(alignment: .leading) {
                        Text("Nieuwe pincode")
                        OTPField(numberOfFields: 4, otp: $viewModel.newPin)
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
                .alert(isPresented: $viewModel.isAlertFailure, error: viewModel.error) { }
                .overlay {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
            
            HStack {
                ButtonVariant(label: "Opslaan") {
                    Task {
                        await viewModel.updatePin() {
                            onSuccess()
                            dismiss()
                        }
                    }
                }
            }.padding()
        }
    }
}
