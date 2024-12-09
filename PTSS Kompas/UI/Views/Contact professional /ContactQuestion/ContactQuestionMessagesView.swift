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
                            //TODO Check senderIf if left or right
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
                        
                        ButtonVariant(label: "Probeer opnieuw"){
                            viewModel.fetchQuestionMessages(questionId: question.id)
                        }
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
            HStack(alignment: .bottom) {
                TextField(
                    "Nieuw bericht..",
                    text: $viewModel.newMessageContent,
                    axis: .vertical
                )
                .lineLimit(1...4)
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.dark, lineWidth: 2)
                )
                ButtonVariant(iconRight: "paperplane") {
                    viewModel.addMessage(content: viewModel.newMessageContent)
                }.frame(width: 50)
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
