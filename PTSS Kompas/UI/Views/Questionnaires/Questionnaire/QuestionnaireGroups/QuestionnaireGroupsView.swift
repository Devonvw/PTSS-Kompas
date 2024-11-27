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
    let groups = [QuestionnaireGroup.example]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(questionnaire.title)
                .multilineTextAlignment(.leading)
                .font(.headline)
                .foregroundColor(.dark).frame(maxWidth: .infinity, alignment: .leading)
            Text("0 van de \(groups.count) groepen voltooid")
                .multilineTextAlignment(.leading)
                .font(.body)
                .foregroundColor(.dark).frame(maxWidth: .infinity, alignment: .leading)
            HStack(alignment: .center) {
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                Text("Je hoeft de vragenlijst ").font(.body)
                    + Text("niet in één keer ")
                        .bold()
                    + Text("in te vullen. Het is mogelijk om op een later moment terug te keren.")
            }.padding(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .cornerRadius(8)
            
        }.padding(.horizontal).padding(.top)
        VStack(alignment: .leading) {
            ScrollView {
                LazyVStack(spacing: 5) {
                    ForEach(groups) { group in
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
                        
                        Button(action: {
                            viewModel.fetchQuestionnaireGroups(questionnaireId: questionnaire.id)
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
                viewModel.fetchQuestionnaireGroups(questionnaireId: questionnaire.id)
            }
            .refreshable{viewModel.fetchQuestionnaireGroups(questionnaireId: questionnaire.id)}
            .navigationBarItems(
                trailing:
                    Button(action: {
                    }) {
                        Label("Search", systemImage: "magnifyingglass")
                    }
            )
            ButtonVariant(label: "Afronden", disabled: true) {}
        }.padding()
    }
}

#Preview {
    QuestionnairesView()
}
