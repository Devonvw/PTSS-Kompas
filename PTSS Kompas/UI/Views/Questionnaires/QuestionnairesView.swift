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
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.questionnaires) { questionnaire in
                        NavigationLink(destination: QuestionnaireView(questionnaire: questionnaire)) {
                            QuestionnaireListItem(questionnaire: questionnaire)
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    Task {
                                        await viewModel.fetchMoreQuestionnaires(questionnaire: questionnaire)
                                    }
                                }
                        }.disabled(questionnaire.isFinished)
                    }
                }
                .padding()
                if viewModel.isFailure {
                    VStack(spacing: 16) {
                        Text("Het is niet gelukt om de vragenlijsten op te halen.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()

                        ButtonVariant(label: "Probeer opnieuw"){
                            Task {
                                await viewModel.fetchQuestionnaires()
                            }
                        }
                    }
                    .padding()
                }
                else if viewModel.isLoading {
                    Loading()
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
            .refreshable{Task { await viewModel.refreshQuestionnaires()}}
            .searchable(text: $viewModel.searchText, prompt: "Zoeken")
            .navigationTitle("Vragenlijsten")
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

#Preview {
    QuestionnairesView()
}
