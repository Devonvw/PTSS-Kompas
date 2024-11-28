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
    @State var question2 = QuestionnaireQuestion.example
    
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
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(height: 120)
                            .padding(4).frame(alignment: .center)
                    } else if let question = viewModel.question {
                        Text("Vraag ").font(.subheadline) + Text("\(question.order)").bold().font(.subheadline) + Text(" van \(group.questionsCount)").font(.subheadline)
                        
                        Text(question.situation)
                            .font(.body)
                            .foregroundColor(.dark)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 24)
                        
                        //                    ForEach($question.subQuestions) { subQuestion in
                        //                        SubQuestionItem(subQuestion: subQuestion)
                        //                    }
                        //                    if let $question = $viewModel.question {
                        //                        ForEach($question.subQuestions { $subQuestion in
                        //                            SubQuestionItem(subQuestion: $subQuestion)
                        //                        }
                        //                    }
                        
                        //                    if let question = viewModel.question {
                        //                        ForEach(question.subQuestions.indices, id: \.self) { index in
                        //                            if let $questionBinding = $viewModel.question {
                        //                                if let test = $questionBinding {
                        //                                    if let subQuestions = test?.subQuestions {
                        //                                        if let subQuestion = subQuestions[index] {
                        //                                            SubQuestionItem(subQuestion:subQuestion)
                        //                                        }
                        //                                    }
                        //                                }
                        //                            }
                        //                        }
                        //                    }
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
            }
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
