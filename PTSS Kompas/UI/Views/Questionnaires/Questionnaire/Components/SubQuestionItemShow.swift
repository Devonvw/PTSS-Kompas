//
//  SubQuestionItemShow.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import SwiftUI

struct SubQuestionItemShow: View {
    let subQuestion: QuestionnaireSubQuestion
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(subQuestion.text)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.dark)
                    .padding(.bottom, 2)
                
            }
            if let description = subQuestion.description {
                Text(description)
                    .font(.body)
                    .foregroundColor(.dark)
                    .padding(.bottom, 6)
            }
            HStack(alignment: .top) {
                ForEach(subQuestion.answerOptions) { answerOption in
                    VStack(alignment: .center) {
                        ButtonVariant(label: answerOption.label, variant: .light) {}.disabled(true)
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
