//
//  QuestionnaireListItem.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 26/11/2024.
//

import SwiftUI

struct QuestionnaireListItem: View {
    let questionnaire: Questionnaire
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(questionnaire.title)
                .font(.headline)
                .foregroundColor(.dark)
            
            Text("Geschatte tijd: \(questionnaire.estimatedTimeOfCompletion)")
                .font(.subheadline)
                .foregroundColor(.dark)
                .padding(.bottom, 10)
            
            Text(questionnaire.description)
                .font(.body)
                .foregroundColor(.dark)
                .lineLimit(4)
                .truncationMode(.tail)
                .padding(.bottom, 10)
                .multilineTextAlignment(.leading)
            
            if questionnaire.isFinished {
                HStack {
                    Text("Voltooid!")
                        .font(.headline)
                        .foregroundColor(.dark)
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.dark)
                }
            } else {
                ButtonVariant(label: "Start", variant: .light){}.disabled(true)
            }
        }
        .padding()
        .background(questionnaire.isFinished ? .light1  : .light2)
        .cornerRadius(8)
    }
}

#Preview {
    QuestionnaireListItem(questionnaire: Questionnaire.example)
}
