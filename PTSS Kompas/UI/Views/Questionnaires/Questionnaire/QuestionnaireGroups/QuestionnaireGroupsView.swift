//
//  QuestionnaireGroupsView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import SwiftUI

struct QuestionnaireGroupsView: View {
    @StateObject var viewModel = QuestionnaireGroupsViewModel()
    
    let questionnaire: Questionnaire
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(questionnaire.title)
                .multilineTextAlignment(.leading)
                .font(.headline)
                .foregroundColor(.dark).frame(maxWidth: .infinity, alignment: .leading)
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(height: 6)
                    .padding(4)
            } else {
                Text("\(viewModel.completedGroups) van de \(viewModel.groups.count) groepen voltooid")
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                    .foregroundColor(.dark).frame(maxWidth: .infinity, alignment: .leading)
            }
            HStack(alignment: .center) {
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                Text("Je hoeft de vragenlijst").font(.subheadline)
                + Text(" niet in één keer ")
                    .bold().font(.subheadline)
                + Text("in te vullen. Het is mogelijk om op een later moment terug te keren.").font(.subheadline)
            }.padding(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .cornerRadius(8)
            
        }.padding(.horizontal).padding(.top)
        VStack(alignment: .leading) {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.groups) { group in
                        NavigationLink(destination: QuestionnaireQuestionView(questionnaire: questionnaire,group: group)) {
                            QuestionnaireGroupListItem(group: group)
                                .frame(maxWidth: .infinity)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                if viewModel.isFailure {
                    VStack(spacing: 16) {
                        Text("Het is niet gelukt om de groepen op te halen.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        ButtonVariant(label: "Probeer opnieuw", iconRight: "arrow.clockwise", action: {
                            Task {
                                await viewModel.fetchQuestionnaireGroups(questionnaireId: questionnaire.id)
                            }
                        })
                    }
                    .padding()
                }
                else if viewModel.isLoading {
                    Loading()
                }
                else if viewModel.groups.isEmpty {
                    VStack(spacing: 16) {
                        Text("Deze vragenlijst heeft geen groepen!")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                }
            }
            .onAppear{
                Task {
                    await viewModel.fetchQuestionnaireGroups(questionnaireId: questionnaire.id)
                }
            }
            .refreshable{Task { await viewModel.fetchQuestionnaireGroups(questionnaireId: questionnaire.id)}}
            .navigationBarItems(
                trailing:
                    NavigationLink(destination: QuestionnaireView(questionnaire: questionnaire)) {
                        VStack(alignment: .center) {
                            Label("Info", systemImage: "info.circle")
                            Text("Uitleg").font(.caption)
                        }
                    }
            )
            ButtonVariant(label: "Afronden", disabled: true) {}
        }.padding()
    }
}

#Preview {
    QuestionnairesView()
}
