//
//  SubQuestionItem.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import SwiftUI

struct SubQuestionItem: View {
    let subQuestion: QuestionnaireSubQuestion
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(subQuestion.text)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.dark)
                .padding(.bottom, 2)
            Text(subQuestion.description)
                .font(.body)
                .foregroundColor(.dark)
                .padding(.bottom, 6)
            HStack(alignment: .top) {
                ForEach(subQuestion.answerOptions) { answerOption in
                    VStack(alignment: .center) {
                        ButtonVariant(label: answerOption.value, variant: .light) {}.disabled(true)
                        Text(answerOption.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                    }
                }
            }
        }
        
    }
}

#Preview {
    SubQuestionItem(subQuestion: QuestionnaireSubQuestion.example)
}
