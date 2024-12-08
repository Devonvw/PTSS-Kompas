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
                self?.refreshChatQuestions()
            }
            .store(in: &cancellables)
    }
    
    func fetchChatMessages(direction: PageDirection) {
        isLoading = true
        isFailure = false
        
        if ((pagination?.nextCursor == nil || pagination?.nextCursor == "") && (pagination?.previousCursor == nil || pagination?.previousCursor == "") ) {
            messages = []
        }
        
        apiService.getChatMessages(pageDirection: direction, cursor: direction == .Next ? pagination?.nextCursor : pagination?.nextCursor, search: debouncedSearchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    if (direction == .Previous) {
                        // Upward scroll, older messages
                        self?.messages.insert(contentsOf: data.data, at: 0)
                    } else {
                        // Downward scroll, newer messages
                        self?.messages.append(contentsOf: data.data)
                    }
                    self?.pagination = data.pagination
                case .failure(let error):
                    self?.isFailure = true
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func refreshChatQuestions() {
        pagination = nil
        fetchChatMessages(direction: .Next)
    }
    
    func fetchNextQuestionMessages(message: ChatMessage) {
        guard let lastMessage = messages.last, lastMessage.id == message.id else {
            return
        }
        
        guard pagination?.nextCursor != nil, pagination?.nextCursor != "", !isLoading else {
            return
        }
        
        fetchChatMessages(direction: .Next)
    }
    
    func fetchPreviousQuestionMessages(message: ChatMessage) {
        guard let firstMessage = messages.first, firstMessage.id == message.id else {
            return
        }
        
        guard pagination?.previousCursor != nil, pagination?.previousCursor != "", !isLoading else {
            return
        }
        
        fetchChatMessages(direction: .Previous)
    }
    
    func addMessage(content: String) {
        let createMessage = CreateChatMessage(content: content)
        
        apiService.addMessage(createMessage: createMessage) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newMessage):
                    self?.messages.append(newMessage)
                    self?.newMessageContent = ""
                case .failure(let error):
                    self?.isFailure = true
                    print("Error adding message: \(error)")
                }
            }
        }
    }
}

