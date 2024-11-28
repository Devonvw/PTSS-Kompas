//
//  QuestionnaireGroupListItem.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import SwiftUI

struct QuestionnaireGroupListItem: View {
    let group: QuestionnaireGroup
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(group.title)
                .font(.headline)
                .foregroundColor(.dark)
                .multilineTextAlignment(.leading)

            if group.isFinished {
                HStack {
                    Text("Voltooid!")
                        .font(.subheadline)
                        .foregroundColor(.dark)
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.dark)
                }
            } else {
                Text("Nog \(group.totalQuestions - group.completedQuestions) vragen in te vullen")
                    .font(.caption)
                    .foregroundColor(.dark)
            }
            Spacer().frame(maxWidth: .infinity, maxHeight: 0)
        }
        .padding()
        .background(group.isFinished ? .light1 : .light2)
        .cornerRadius(8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    QuestionnaireGroupListItem(group: QuestionnaireGroup.example)
}
