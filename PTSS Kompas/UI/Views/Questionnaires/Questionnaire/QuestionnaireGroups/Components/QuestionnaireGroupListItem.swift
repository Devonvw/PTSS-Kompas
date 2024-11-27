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
                        .font(.headline)
                        .foregroundColor(.dark)
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            } else {
                Text("Nog \(group.questionsLeft) vragen in te vullen")
                    .font(.caption)
                    .foregroundColor(.dark)
            }
            Spacer().frame(maxWidth: .infinity, maxHeight: 0)
        }
        .padding()
        .background(.light2)
        .cornerRadius(8)
        .frame(maxWidth: .infinity, alignment: .leading) // Ensure the entire card stretches but aligns left

    }
}

#Preview {
    QuestionnaireGroupListItem(group: QuestionnaireGroup.example)
}
