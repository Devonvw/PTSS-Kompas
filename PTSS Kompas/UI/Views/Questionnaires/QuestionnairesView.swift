//
//  QuestionnairesView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 25/11/2024.
//

import SwiftUI

struct QuestionnairesView: View {
    @StateObject var viewModel = QuestionnairesViewModel()
        
    var body: some View {
        NavigationView {
            ScrollView {
//                if !viewModel.isLoading  {
//                    HStack {
//                        Text("\(viewModel.pagination?.totalItems ?? 0) vragenlijsten")
//                            .font(.caption).fontWeight(.semibold)
//                    }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
//                }
                    
                LazyVStack(spacing: 5) {
                    ForEach(viewModel.questionnaires) { questionnaire in
                        NavigationLink(destination: QuestionnaireView(questionnaire: questionnaire)) {
                            QuestionnaireListItem(questionnaire: questionnaire)
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    viewModel.fetchMoreQuestionnaires(questionnaire: questionnaire)
                                }
                        }
                    }
                }
                .padding()
                if viewModel.isFailure {
                    VStack(spacing: 16) {
                        Text("Het is niet gelukt om de vragenlijsten op te halen.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button(action: {
                            viewModel.fetchQuestionnaires()
                        }) {
                            Text("Retry")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal, 40)
                    }
                    .padding()
                }
                else if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(height: 120)
                        .padding(4)
                }
                else if viewModel.questionnaires.isEmpty && viewModel.searchText.isEmpty {
                    VStack(spacing: 16) {
                        Text("Je hebt geen vragenlijsten!")
                            .font(.title)
                            .foregroundColor(.gray)
                        
                        Text("Er zijn nog geen vragenlijsten aan jou toegewezen.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                }
                else if viewModel.questionnaires.isEmpty && !viewModel.searchText.isEmpty {
                    VStack(spacing: 16) {
                        Text("Er zijn geen vragenlijsten gevonden met deze zoekopdracht.")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                }
            }
            .refreshable{viewModel.refreshQuestionnaires()}
            .searchable(text: $viewModel.searchText, prompt: "Zoeken")
            .navigationTitle("Vragenlijsten")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    QuestionnairesView()
}
