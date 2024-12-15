//
//  ContactQuestion.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 04/12/2024.
//

import SwiftUI

struct ContactQuestionView: View {
    let question: ContactQuestion
    
    @State private var isExpanded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    DisclosureGroup(isExpanded: $isExpanded) {
                        VStack(alignment: .leading) {
                            Spacer().frame(maxWidth: .infinity, maxHeight: 0)

                            Text(question.content)
                                .font(.body)
                                .foregroundColor(.dark)
                                .padding(.bottom, 16)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity)
                    } label: {
                        Text(question.subject)
                            .font(.headline)
                            .foregroundColor(.dark).multilineTextAlignment(.leading)
                    }
                    Text("Aangemaakt op \(formatDate(from: question.createdAt, to: "dd-MM-yyyy"))")
                        .font(.caption)
                        .foregroundColor(.dark).padding(.bottom, 16)
                    
                    ContactQuestionMessagesView(question: question)
            }
        }.padding()
    }
}

#Preview {
    ContactQuestionView(question: ContactQuestion.example)
}
