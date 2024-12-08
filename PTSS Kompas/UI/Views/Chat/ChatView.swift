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
                if viewModel.isFailure {
                    VStack(spacing: 16) {
                        Text("Het is niet gelukt om de berichten op te halen.")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button(action: {
                            viewModel.refreshChatQuestions()
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
            }.refreshable{viewModel.refreshChatQuestions()}
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
            viewModel.refreshChatQuestions()
        }
    }
}

#Preview {
    ChatView()
}