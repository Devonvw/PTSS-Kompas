//
//  CreateContactQuestionView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import SwiftUI

struct CreateToolView: View {
    @StateObject var viewModel = CreateToolViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let onSuccess: (Tool) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Voeg een nieuwe hulpmiddel toe") .font(.headline)
                .foregroundColor(.dark)
            Spacer().frame(maxWidth: .infinity, maxHeight: 0)
        }.padding()
        
        Form {
            Section
            {
               
                MultiSelector(
                    label: Text("Categorieën"),
                    options: viewModel.categories,
                    optionToString: { $0.category },
                    selected: $viewModel.selectedCategories
                )
                VStack(alignment: .leading) {
                    Text("Naam")
                    TextField(
                        "Geef een duidelijke naam aan het nieuwe hulpmiddel..",
                        text: $viewModel.newToolName,
                        axis: .vertical
                    )
                    .lineLimit(4...10)
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.dark, lineWidth: 2)
                    )
                }
                VStack(alignment: .leading) {
                    Text("Beschrijving")
                    TextField(
                        "Geef een duidelijke beschrijving aan het nieuwe hulpmiddel..",
                        text: $viewModel.newToolDescription,
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
            }.onAppear {
                Task {
                                        await viewModel.fetchToolCategories()
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
            ButtonVariant(label: "Voeg hulpmiddel toe") {
                Task {
                    await viewModel.addTool() { newTool in
                        onSuccess(newTool)
                        dismiss()
                    }
                }
            }
        }.padding()
    }
}

#Preview {
    CreateContactQuestionView()
}
