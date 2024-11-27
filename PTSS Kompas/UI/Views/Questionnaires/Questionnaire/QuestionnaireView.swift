//
//  QuestionnaireView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import SwiftUI

struct QuestionnaireView: View {
    @StateObject var viewModel = QuestionnaireViewModel()
    
    let questionnaire: Questionnaire
    let questionnaireExplanation = QuestionnaireExplanation.example
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(questionnaire.title) .font(.headline)
                        .foregroundColor(.dark)
                    Text("Geschatte tijd: \(questionnaire.estimatedTimeOfCompletion)")
                        .font(.subheadline)
                        .foregroundColor(.dark)
                        .padding(.bottom, 10)
                    
                    Text(questionnaire.description)
                        .font(.body)
                        .foregroundColor(.dark)
                        .fixedSize(horizontal: false, vertical: true) // Allow multiline text
                        .padding(.bottom, 16)
                    
                    ForEach(questionnaireExplanation.questions) { question in
                        SubQuestionItem(subQuestion: question)
                    }
                }
            }
            NavigationLink(destination: QuestionnaireGroupsView(questionnaire: questionnaire)) {
                ButtonVariant(label: "Naar vragen") {}.disabled(true)
            }
        }.padding()
            .onAppear {
                Task {
                    viewModel.fetchQuestionnaire(id: questionnaire.id)
                }
            }
    }
}

#Preview {
    QuestionnaireView(questionnaire: Questionnaire.example)
}
