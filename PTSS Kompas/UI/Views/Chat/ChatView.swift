//
//  ChatView.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 08/12/2024.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel = ChatViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 5) {
                    ForEach(viewModel.messages) { message in
                        //TODO Check senderIf if left or right
                        Message(title: message.senderName, content: message.content, date: message.sentAt, type: .left)
                            .frame(maxWidth: .infinity)
                            .onAppear {
                                Task {
                                    await viewModel.fetchNextQuestionMessages(message: message)
                                    await viewModel.fetchPreviousQuestionMessages(message: message)
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
                            Task {
                                await viewModel.refreshChatQuestions()
                            }
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
            }
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
                    Task {
                        await viewModel.addMessage(content: viewModel.newMessageContent)
                    }
                }.frame(width: 50)
            }
            
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.refreshChatQuestions()
            }
        }
        .searchable(text: $viewModel.searchText)
        .navigationTitle("Vragenlijsten")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChatView()
}
