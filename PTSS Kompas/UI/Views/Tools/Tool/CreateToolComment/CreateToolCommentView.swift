//
//  CreateContactQuestionView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import SwiftUI

struct CreateToolCommentView: View {
    @StateObject var viewModel = CreateToolCommentViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let tool: Tool
    let onSuccess: (ToolComment) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Voeg een nieuwe opmerking toe") .font(.headline)
                .foregroundColor(.dark)
            Spacer().frame(maxWidth: .infinity, maxHeight: 0)
        }.padding()
        
        Form {
            Section
            {
               
                VStack(alignment: .leading) {
                    Text("Opmerking")
                    TextField(
                        "Beschrijf je opmerking in detail..",
                        text: $viewModel.newCommentContent,
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
                Task {
                    await viewModel.addComment(toolId: tool.id) { newComment in
                        onSuccess(newComment)
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
