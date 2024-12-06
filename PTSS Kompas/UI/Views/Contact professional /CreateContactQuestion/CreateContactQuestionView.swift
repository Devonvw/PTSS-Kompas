//
//  CreateContactQuestionView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import SwiftUI

struct CreateContactQuestionView: View {
    @StateObject var viewModel = CreateContactQuestionViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        //        Form {
        //
        //            Section {
        //                Section("Onderwerp") {
        //                    TextField(
        //                        "Kort onderwerp van je vraag..",
        //                        text: $viewModel.newQuestionSubject,
        //                        axis: .vertical
        //                    )
        //                    .lineLimit(1...3)
        //                    .padding(12)
        //                    .overlay(
        //                        RoundedRectangle(cornerRadius: 5)
        //                            .stroke(Color.dark, lineWidth: 2)
        //                    )
        //                }
        //            } footer: {
        //                if case .validation(let err) = viewModel.error {
        //                    Text(err.localizedDescription)
        //                        .foregroundStyle(.red)
        //                }
        //
        //            }
        //        }
        //                    .disabled(vm.state == .submitting)
        //                    .navigationTitle("Create")
        //                    .toolbar {
        //                        ToolbarItem(placement: .primaryAction) {
        //                            done
        //                        }
        //                    }
        //                    .onChange(of: vm.state) { formState in
        //                        if formState == .successful {
        //                            dismiss()
        //                            successfulAction()
        //                        }
        //                    }
        //                    .alert(isPresented: $vm.hasError,
        //                           error: vm.error) { }
        //                    .overlay {
        //
        //                        if vm.state == .submitting {
        //                            ProgressView()
        //                        }
        //                    }
        VStack(alignment: .leading) {
            Text("Stel een nieuwe vraag") .font(.headline)
                .foregroundColor(.dark)
            Text("Omschrijving hoe het werkt")
                .font(.subheadline)
                .foregroundColor(.dark)
                .padding(.bottom, 10)
            Spacer().frame(maxWidth: .infinity, maxHeight: 0)
        }.padding()
        
        Form {
            Section
            {
                TextField(
                    "Kort onderwerp van je vraag..",
                    text: $viewModel.newQuestionSubject,
                    axis: .vertical
                )
                .lineLimit(1...3)
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.dark, lineWidth: 2)
                )
            } footer: {
                if case .validation(let err) = viewModel.error,
                   let errorDesc = err.errorDescription {
                    Text(errorDesc)
                        .foregroundStyle(.red)
                }
            }
            Section("Beschrijving") {
                TextField(
                    "Beschrijf je vraag of situatie in detail..",
                    text: $viewModel.newQuestionContent,
                    axis: .vertical
                )
                .lineLimit(4...10)
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.dark, lineWidth: 2)
                )
            }
        }.padding(0)
            .background(.clear)
            .scrollContentBackground(.hidden)
            .alert(isPresented: $viewModel.isFailure, error: viewModel.error) { }
        //            .navigationTitle("Stel een nieuwe vraag")
        //            .toolbar {
        //                ToolbarItem(placement: .primaryAction) {
        //                    Button("Klaar") {
        //                        dismiss()
        //                    }
        //                    .accessibilityIdentifier("doneBtn")
        //                }
        //            }
        HStack {
            ButtonVariant(label: "Stel nieuwe vraag") {
                viewModel.addQuestion()
            }
        }.padding()
    }
}

#Preview {
    CreateContactQuestionView()
}
