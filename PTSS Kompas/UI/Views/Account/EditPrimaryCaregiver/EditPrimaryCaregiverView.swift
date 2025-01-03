//
//  EditPrimaryCaregiverView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 31/12/2024.
//

import SwiftUI

struct EditPrimaryCaregiverView: View {
    @StateObject var viewModel = EditPrimaryCaregiverViewModel()
    @Environment(\.dismiss) private var dismiss
    
    
    let currentPrimaryCaregiver: User?
    let members: [User]
    let onSuccess: (User) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(height: 0)
                Button("Sluiten") {
                    dismiss()
                }.padding()
            }
            VStack(alignment: .leading) {
                Text("Wijzig de hoofdmantelzorger") .font(.headline)
                    .foregroundColor(.dark)
                Spacer().frame(maxWidth: .infinity, maxHeight: 0)
            }.padding()
            
            Form {
                Section
                {
                    
                    Picker("Familieleden", selection: $viewModel.selectedMember) {
                        ForEach(members, id: \.self) {
                            Text("\($0.firstName) \($0.lastName)").tag($0)
                        }
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
            //            .toolbar {
            //                ToolbarItem(placement: .primaryAction) {
            //                    Button("Klaar") {
            //                        dismiss()
            //                    }
            //                    .accessibilityIdentifier("doneBtn")
            //                }
            //            }
            HStack {
                ButtonVariant(label: "Wijzig hoofdmantelzorger") {
                    Task {
                        await viewModel.editPrimaryCaregiver() { newPrimaryCaregiver in
                            onSuccess(newPrimaryCaregiver)
                            dismiss()
                        }
                    }
                }
            }.padding()
        }.onAppear {
            viewModel.setInitialPrimaryCaregiver(primaryCaregiver: currentPrimaryCaregiver, members: members)
        }
    }
}
