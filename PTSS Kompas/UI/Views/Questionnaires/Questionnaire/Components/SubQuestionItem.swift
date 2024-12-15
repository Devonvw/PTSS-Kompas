//
//  SubQuestionItem.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import SwiftUI

struct SubQuestionItem: View {
    @Binding var subQuestion: QuestionnaireSubQuestion
    @State private var showTooltip = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(subQuestion.text)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.dark)
                    .padding(.bottom, 2)
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        showTooltip.toggle()
                    }
                    .sheet(isPresented: $showTooltip) {
                        VStack(alignment: .leading) {
                            Text(subQuestion.text)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.dark)
                                .padding(.bottom, 2)
                            if let description = subQuestion.description {
                                Text(description)
                                    .font(.body)
                                    .foregroundColor(.dark)
                            }
                        }.padding()
                            .presentationDetents([.height(200)])

                    }
            }.padding(.bottom, 12)
            HStack(alignment: .top) {
                ForEach(subQuestion.answerOptions) { answerOption in
                    let isSelected = subQuestion.answer == answerOption.value
                    VStack(alignment: .center) {
                        ButtonVariant(label: {
                            Text(answerOption.label)
                                .fontWeight(isSelected ? .bold : .regular)
                        }, variant: .light, action: {
                            subQuestion.answer = answerOption.value
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.dark, lineWidth: isSelected ? 8 : 0)
                        )
                        .cornerRadius(8)
                        if let description = answerOption.description {
                            Text(description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
        }
        
    }
}
