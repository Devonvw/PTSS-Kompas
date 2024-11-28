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
                .fixedSize(horizontal: false, vertical: true) // Allow multiline text
                .padding(.bottom, 10)
            
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
        .background(.light2)
        .cornerRadius(8)
    }
}

#Preview {
    QuestionnaireListItem(questionnaire: Questionnaire.example)
}
