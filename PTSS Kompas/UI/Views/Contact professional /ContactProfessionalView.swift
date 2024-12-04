//
//  QuestionnairesView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 25/11/2024.
//

import SwiftUI

struct ContactProfessionalView: View {
    @StateObject var viewModel = ContactProfessionalViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                ScrollView {
                    //                if !viewModel.isLoading  {
                    //                    HStack {
                    //                        Text("\(viewModel.pagination?.totalItems ?? 0) vragenlijsten")
                    //                            .font(.caption).fontWeight(.semibold)
                    //                    }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                    //                }
                    
                    LazyVStack(spacing: 5) {
                        ForEach(viewModel.questions) { question in
                            NavigationLink(destination: ContactQuestionView(question: question)) {
                                ContactQuestionListItem(question: question)
                                    .frame(maxWidth: .infinity)
                                    .onAppear {
                                        viewModel.fetchMoreContactQuestions(question: question)
                                    }
                            }
                        }
                    }
                    
                    if viewModel.isFailure {
                        VStack(spacing: 16) {
                            Text("Het is niet gelukt om de vragen op te halen.")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .padding()
                            
                            Button(action: {
                                viewModel.fetchContactQuestions()
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
                    else if viewModel.questions.isEmpty && viewModel.searchText.isEmpty {
                        VStack(spacing: 16) {
                            Text("Je hebt geen vragen!")
                                .font(.title)
                                .foregroundColor(.gray)
                            
                            Text("Je hebt nog geen vragen gesteld.")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 50)
                    }
                    else if viewModel.questions.isEmpty && !viewModel.searchText.isEmpty {
                        VStack(spacing: 16) {
                            Text("Er zijn geen vragen gevonden met deze zoekopdracht.")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 50)
                    }
                }
                .refreshable{viewModel.refreshContactQuestions()}
                .searchable(text: $viewModel.searchText, prompt: "Zoeken")
                .navigationTitle("Vraag de professional")
                .navigationBarTitleDisplayMode(.inline)
                
                ButtonVariant(label: "Stel nieuwe vraag") {}
            } .padding()
        }
    }
}

#Preview {
    ContactProfessionalView()
}
