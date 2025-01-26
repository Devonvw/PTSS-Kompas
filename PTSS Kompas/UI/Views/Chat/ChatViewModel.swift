//
//  ChatViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 08/12/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingAdding: Bool = false
    @Published var isFailure: Bool = false
    @Published var isFailureAdding: Bool = false
    
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
            
            if direction == .Previous {
                self.messages.insert(contentsOf: data.data, at: 0)
            } else {
                self.messages.append(contentsOf: data.data)
            }
            pagination = data.pagination
            isLoading = false
        } catch {
            isLoading = false
            isFailure = true
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
        isLoadingAdding = true
        
        do {
            let newMessage = try await apiService.addMessage(createMessage: createMessage)
            
            messages.append(newMessage)
            newMessageContent = ""
            isLoadingAdding = false
            
        } catch {
            isFailureAdding = true
            isLoadingAdding = false
        }
    }
    
}

