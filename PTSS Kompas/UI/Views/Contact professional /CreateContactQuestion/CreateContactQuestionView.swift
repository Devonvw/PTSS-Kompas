//
//  CreateContactQuestionView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import SwiftUI

struct CreateContactQuestionView: View {
    @StateObject var viewModel = CreateContactQuestionViewModel()
    
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
            Section("Onderwerp") {
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
