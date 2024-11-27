//
//  QuestionnaireGroupView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import SwiftUI

struct QuestionnaireQuestionView: View {
    @StateObject var viewModel = QuestionnaireViewModel()
    
    let questionnaire: Questionnaire
    let group: QuestionnaireGroup
    let question = QuestionnaireQuestion.example
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(questionnaire.title)
                        .font(.headline)
                        .foregroundColor(.dark)
                    Text(group.title)
                        .font(.subheadline)
                        .foregroundColor(.dark)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 8)
                    
                    HStack(alignment: .center) {
                        ForEach(0..<group.questionsCount, id: \.self) { number in
                            Button(""){}.frame(maxWidth: .infinity, maxHeight: 4).background(.gray.opacity(0.4)).cornerRadius(40)
                        }
                    }.padding(.bottom, 8)
                    
                    Text("Vraag ").font(.subheadline) + Text("\(question.order)").bold().font(.subheadline) + Text(" van \(group.questionsCount)").font(.subheadline)
                    
                    Text(question.situation)
                        .font(.body)
                        .foregroundColor(.dark)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 24)
                    
                    ForEach(question.subQuestions) { subQuestion in
                        SubQuestionItem(subQuestion: subQuestion)
                    }
                }
            }
            ButtonVariant(label: "Volgende", disabled: true, iconRight: "arrow.right") {}
        }.padding()
            .onAppear {
                Task {
                    //                    viewModel.fetchQuestionnaire(id: questionnaire.id)
                }
            }
    }
}

#Preview {
    QuestionnaireQuestionView(questionnaire: Questionnaire.example, group: QuestionnaireGroup.example)
}
