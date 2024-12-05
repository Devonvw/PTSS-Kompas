//
//  ContactQuestionViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 04/12/2024.
//
import Foundation
import Combine
import SwiftUI

final class ContactQuestionMessagesViewModel: ObservableObject {
    @Published var messages: [ContactQuestionMessage] = []
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
    @Published var pagination: Pagination?
    private var cancellables = Set<AnyCancellable>()
    private var searchTextSubject = PassthroughSubject<String, Never>()
    private var debouncedSearchText = ""
    private var questionId: String?
    
    private let apiService = ContactService()
    
    init() {
        debounceSearchText()
    }
    
    private func debounceSearchText() {
        searchTextSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.debouncedSearchText = query
                self?.refreshContactQuestions()
            }
            .store(in: &cancellables)
    }
    
    func fetchQuestionMessages(questionId: String) {
        isLoading = true
        isFailure = false
        self.questionId = questionId
        
        if (pagination?.nextCursor == nil || pagination?.nextCursor == "") {
            messages = []
        }
        
        apiService.getContactQuestionMessages(questionId: questionId, cursor: pagination?.nextCursor, search: debouncedSearchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.messages.append(contentsOf: data.data)
                    self?.pagination = data.pagination
                case .failure(let error):
                    self?.isFailure = true
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func fetchMoreQuestionMessages(message: ContactQuestionMessage) {
        guard let questionId else { return }
        
        guard let lastMessage = messages.last, lastMessage.id == message.id else {
            return
        }
        
        guard pagination?.nextCursor != nil, pagination?.nextCursor != "", !isLoading else {
            return
        }
        
        fetchQuestionMessages(questionId: questionId)
    }
    
    
    func refreshContactQuestions() {
        guard let questionId else { return }
        
        pagination = nil
        fetchQuestionMessages(questionId: questionId)
    }
    
    func addMessage(content: String) {
        guard let questionId else { return }
        
        apiService.addMessage(questionId: questionId, createMessage: CreateContactQuestionMessage(content: content)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newMessage):
                    print("succes")
                    print(newMessage)
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

