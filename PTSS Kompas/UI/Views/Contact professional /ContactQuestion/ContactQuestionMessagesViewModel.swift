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
                Task {
                    await self?.refreshContactQuestions()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchQuestionMessages(questionId: String) async {
        isLoading = true
        isFailure = false
        self.questionId = questionId

        if pagination?.nextCursor == nil || pagination?.nextCursor == "" {
            messages = []
        }

        do {
            let data = try await apiService.getContactQuestionMessages(questionId: questionId, cursor: pagination?.nextCursor, search: debouncedSearchText)
            
            await MainActor.run {
                messages.append(contentsOf: data.data)
                pagination = data.pagination
                isLoading = false
            }
        } catch {
            await MainActor.run {
                isLoading = false
                isFailure = true
            }
            print("Error: \(error)")
        }
    }

    
    func fetchMoreQuestionMessages(message: ContactQuestionMessage) async {
        guard let questionId else { return }
        
        guard let lastMessage = messages.last, lastMessage.id == message.id else {
            return
        }
        
        guard pagination?.nextCursor != nil, pagination?.nextCursor != "", !isLoading else {
            return
        }
        
        await fetchQuestionMessages(questionId: questionId)
    }
    
    
    func refreshContactQuestions() async {
        guard let questionId else { return }
        
        pagination = nil
        await fetchQuestionMessages(questionId: questionId)
    }
    
    func addMessage(content: String) async {
        guard let questionId else { return }
        
        do {
            let newMessage = try await apiService.addMessage(questionId: questionId, createMessage: CreateContactQuestionMessage(content: content))
            
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

