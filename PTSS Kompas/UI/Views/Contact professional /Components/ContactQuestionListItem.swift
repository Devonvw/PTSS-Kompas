//
//  QuestionnaireListItem.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 26/11/2024.
//

import SwiftUI

struct ContactQuestionListItem: View {
    let question: ContactQuestion
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(question.subject)
                .font(.headline)
                .foregroundColor(.dark)
            
            Text(question.content)
                .font(.body)
                .foregroundColor(.dark)
                .lineLimit(4)
                .truncationMode(.tail)
                .padding(.bottom, 10)
                .multilineTextAlignment(.leading)
            
            Text("Aangemaakt op \(formatDate(from: question.createdAt, to: "dd-MM-yyyy"))")
                .font(.caption)
                .foregroundColor(.dark)
            if question.isClosed {
                HStack {
                    Text("Afgesloten door de professional")
                        .font(.headline)
                        .foregroundColor(.dark)
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.dark)
                }
            } else if question.newAnswer {
                ButtonVariant(label: "Bekijk nieuw antwoord", variant: .light){}.disabled(true)
            }
            else {
                ButtonVariant(label: "Bekijk", variant: .light){}.disabled(true)
            }
        }
        .padding()
        .background(.light2)
        .cornerRadius(8)
    }
}

#Preview {
    ContactQuestionListItem(question: .example)
}
