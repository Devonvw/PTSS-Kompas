//
//  QuestionnaireGroupView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import SwiftUI

struct QuestionnaireQuestionView: View {
    @StateObject var viewModel = QuestionnaireQuestionViewModel()
    
    @State private var shouldNavigate = false
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
                        Loading()
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
                        Text("Vraag ").font(.subheadline) + Text("\(viewModel.questionOrder)").bold().font(.subheadline) + Text(" van \(group.totalQuestions)").font(.subheadline)
                        
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
                                ).padding(.bottom, 16)
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
                        viewModel.backQuestion(questionnaireId: questionnaire.id, groupId: group.id)
                    }.frame(width: 80).padding(.trailing, 10)
                }
                if viewModel.isLastQuestion {
                    NavigationLink(
                       destination: QuestionnaireGroupsView(questionnaire: questionnaire),
                       isActive: $shouldNavigate
                   ) {
                       EmptyView()
                   }
//                    NavigationLink(destination: QuestionnaireGroupsView(questionnaire: questionnaire)) {
                        ButtonVariant(label: "Volgende", iconRight: "arrow.right") {
                            Task {
                                await viewModel.nextQuestion(questionnaireId: questionnaire.id, groupId: group.id) {
                                    shouldNavigate = true
                                }
                            }
                        }
//                    }
                } else {
                    ButtonVariant(label: {
                        if viewModel.isSaving {
                            VStack(alignment: .center) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(height: 16)
                                    .padding(4)
                                Spacer().frame(maxWidth: .infinity, maxHeight: 0)
                            }
                        } else {
                            Text("Volgende")
                        }
                    }, iconRight: "arrow.right") {
                        Task {
                            await viewModel.nextQuestion(questionnaireId: questionnaire.id, groupId: group.id) {
                                
                            }
                        }
                    }
                }
                
            }
        }.padding()
            .onAppear {
                Task {
                    await viewModel.fetchQuestionnaireQuestions(questionnaireId: questionnaire.id, groupId: group.id)
                }
            }
    }
}

#Preview {
    QuestionnaireQuestionView(questionnaire: Questionnaire.example, group: QuestionnaireGroup.example)
}
