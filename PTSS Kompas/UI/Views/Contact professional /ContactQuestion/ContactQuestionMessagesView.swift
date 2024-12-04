//
//  ContactQuestionMessagesView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 04/12/2024.
//
import SwiftUI

struct ContactQuestionMessagesView: View {
    @StateObject var viewModel = ContactQuestionMessagesViewModel()
    
    let question: ContactQuestion
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Berichten (\(viewModel.messages.count))")
                        .font(.headline)
                        .foregroundColor(.dark)
                    
                    LazyVStack(alignment: .leading, spacing: 5) {
                        ForEach(viewModel.messages) { message in
                            Message(title: message.senderName, content: message.content, date: message.createdAt, type: .left)
                                .frame(maxWidth: .infinity)
                                .onAppear {
                                    viewModel.fetchMoreQuestionMessages(message: message)
                                }
                        }
                    }
                }
                
                if viewModel.isFailure {
                    VStack(spacing: 16) {
                        Text("Het is niet gelukt om de berichten op te halen.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button(action: {
                            viewModel.fetchQuestionMessages(questionId: question.id)
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
                else if viewModel.messages.isEmpty && viewModel.searchText.isEmpty {
                    VStack(spacing: 16) {
                        Text("Er zijn nog geen berichten verzonden.")
                            .font(.title)
                            .foregroundColor(.gray)
                        
                        Text("Verstuur een bericht door een bericht te schrijven in het onderstaande veld en te klikken op de rechter knop.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                }
                else if viewModel.messages.isEmpty && !viewModel.searchText.isEmpty {
                    VStack(spacing: 16) {
                        Text("Er zijn geen berichten gevonden met deze zoekopdracht.")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 50)
                }
            }.refreshable{viewModel.refreshContactQuestions()}
//                .searchable(text: $viewModel.searchText, placement: .sidebar, prompt: "Zoeken")
            ButtonVariant(label: "Stel nieuwe vraag") {}
            
            HStack {
                TextField(
                    "Nieuw bericht..",
                    text: $viewModel.newMessageContent
                ).padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.dark, lineWidth: 2)
                    )
                ButtonVariant(label: "", iconRight: "paperplane") {}.frame(width: 50)
            }

        }
        .onAppear {
            viewModel.fetchQuestionMessages(questionId: question.id)
        }
    }
}

#Preview {
    ContactQuestionMessagesView(question: ContactQuestion.example)
}
