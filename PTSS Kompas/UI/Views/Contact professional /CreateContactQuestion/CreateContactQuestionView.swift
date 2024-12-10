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
                VStack(alignment: .leading) {
                    Text("Onderwerp")
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
                }
                VStack(alignment: .leading) {
                    Text("Beschrijving")
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
            ButtonVariant(label: "Stel nieuwe vraag") {
                viewModel.addQuestion {
                    dismiss()
                }
            }
        }.padding()
    }
}

#Preview {
    CreateContactQuestionView()
}
