//
//  ChatViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 08/12/2024.
//

import Foundation
import Combine
import SwiftUI

final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    @Published var searchText = "" {
        didSet {
            if (searchText != oldValue) {
                searchTextSubject.send(searchText)
            }
        }
    }
    @Published var newMessageContent: String = ""
    @Published var pagination: BiDirectionalPagination?
    private var cancellables = Set<AnyCancellable>()
    private var searchTextSubject = PassthroughSubject<String, Never>()
    private var debouncedSearchText = ""
    
    private let apiService = ChatService()
    
    init() {
        debounceSearchText()
    }
    
    private func debounceSearchText() {
        searchTextSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.debouncedSearchText = query
                Task {
                    await self?.refreshChatQuestions()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchChatMessages(direction: PageDirection) async {
        isLoading = true
        isFailure = false
        
        if (pagination?.nextCursor == nil || pagination?.nextCursor == "") &&
           (pagination?.previousCursor == nil || pagination?.previousCursor == "") {
            messages = []
        }
        
        do {
            let data = try await apiService.getChatMessages(
                pageDirection: direction,
                cursor: direction == .Next ? pagination?.nextCursor : pagination?.previousCursor,
                search: debouncedSearchText
            )
            
            await MainActor.run {
                if direction == .Previous {
                    // Upward scroll, older messages
                    self.messages.insert(contentsOf: data.data, at: 0)
                } else {
                    // Downward scroll, newer messages
                    self.messages.append(contentsOf: data.data)
                }
                self.pagination = data.pagination
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.isFailure = true
            }
            print("Error: \(error)")
        }
    }

    
    func refreshChatQuestions() async {
        pagination = nil
        await fetchChatMessages(direction: .Next)
    }
    
    func fetchNextQuestionMessages(message: ChatMessage) async {
        guard let lastMessage = messages.last, lastMessage.id == message.id else {
            return
        }
        
        guard pagination?.nextCursor != nil, pagination?.nextCursor != "", !isLoading else {
            return
        }
        
        await fetchChatMessages(direction: .Next)
    }
    
    func fetchPreviousQuestionMessages(message: ChatMessage) async {
        guard let firstMessage = messages.first, firstMessage.id == message.id else {
            return
        }
        
        guard pagination?.previousCursor != nil, pagination?.previousCursor != "", !isLoading else {
            return
        }
        
        await fetchChatMessages(direction: .Previous)
    }
    
    func addMessage(content: String) async {
        let createMessage = CreateChatMessage(content: content)
        
        do {
            let newMessage = try await apiService.addMessage(createMessage: createMessage)
            
            await MainActor.run {
                messages.append(newMessage)
                newMessageContent = ""
            }
        } catch {
            await MainActor.run {
                isFailure = true
            }
            print("Error adding message: \(error)")
        }
    }

}

