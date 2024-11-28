//
//  QuestionnaireGroupView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import SwiftUI

struct QuestionnaireQuestionView: View {
    @StateObject var viewModel = QuestionnaireQuestionViewModel()
    
    let questionnaire: Questionnaire
    let group: QuestionnaireGroup
    
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
                    
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(height: 120)
                            .padding(4).frame(alignment: .center)
                    } else if let question = viewModel.question {
                        HStack(alignment: .center) {
                            ForEach(viewModel.questions) { questionItem in
                                Button(""){}.frame(maxWidth: .infinity, maxHeight: 4)
                                    .background(questionItem.isFinished ?.light1 : .gray.opacity(0.4)).cornerRadius(40).overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(Color.dark, lineWidth: questionItem.id == question.id ? 4 : 0)
                                    )
                                    .cornerRadius(40)
                            }
                        }.padding(.bottom, 8)
                        Text("Vraag ").font(.subheadline) + Text("\(question.id)").bold().font(.subheadline) + Text(" van \(group.totalQuestions)").font(.subheadline)
                        
                        Text(question.situation)
                            .font(.body)
                            .foregroundColor(.dark)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 24)
                            .padding(.top, 4)
                        
                        if let question = viewModel.question {
                            ForEach(question.subQuestions.indices, id: \.self) { index in
                                SubQuestionItem(
                                    subQuestion: Binding(
                                        get: { question.subQuestions[index] },
                                        set: { newValue in viewModel.question?.subQuestions[index] = newValue }
                                    )
                                )
                            }
                        }
                    }
                }
            }.navigationBarItems(
                trailing:
                    NavigationLink(destination: QuestionnaireView(questionnaire: questionnaire)) {
                        VStack(alignment: .center) {
                            Label("Info", systemImage: "info.circle")
                            Text("Uitleg").font(.caption)
                        }
                    }
            )
            HStack(alignment: .center) {
                if !viewModel.isFirstQuestion {
                    ButtonVariant(label: "", iconRight: "arrow.left") {
                        viewModel.backQuestion()
                    }.frame(width: 80)
                }
                if viewModel.isLastQuestion {
                    NavigationLink(destination: QuestionnaireGroupsView(questionnaire: questionnaire)) {
                        ButtonVariant(label: "Volgende", iconRight: "arrow.right") {
                            viewModel.nextQuestion()
                        }.disabled(true)
                    }
                } else {
                    ButtonVariant(label: "Volgende", iconRight: "arrow.right") {
                        viewModel.nextQuestion()
                    }
                }
                
            }
        }.padding()
            .onAppear {
                viewModel.fetchQuestionnaireQuestions(questionnaireId: questionnaire.id, groupId: group.id)
            }
    }
}

#Preview {
    QuestionnaireQuestionView(questionnaire: Questionnaire.example, group: QuestionnaireGroup.example)
}
