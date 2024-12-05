//
//  ContactProfessionalViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

import Foundation
import Combine
import SwiftUI

final class ContactProfessionalViewModel: ObservableObject {
    @Published var questions: [ContactQuestion] = []
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    @Published var searchText = "" {
        didSet {
            if (searchText != oldValue) {
                searchTextSubject.send(searchText)
            }
        }
    }
    @Published var pagination: Pagination?
    private var cancellables = Set<AnyCancellable>()
    private var searchTextSubject = PassthroughSubject<String, Never>()
    private var debouncedSearchText = ""
    @Published var shouldShowCreate = false

    private let apiService = ContactService()
    
    init() {
        debounceSearchText()
        fetchContactQuestions()
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
    
    func fetchContactQuestions() {
        isLoading = true
        isFailure = false
        if (pagination?.nextCursor == nil || pagination?.nextCursor == "") {
            questions = []
        }
        
        apiService.getContactQuestions(cursor: pagination?.nextCursor, search: debouncedSearchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    print("kaas", data.data)
                    self?.questions.append(contentsOf: data.data)
                    self?.pagination = data.pagination
                case .failure(let error):
                    self?.isFailure = true
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func fetchMoreContactQuestions(question: ContactQuestion) {
        guard let lastQuestion = questions.last, lastQuestion.id == question.id else {
            return
        }
        
        guard pagination?.nextCursor != nil, pagination?.nextCursor != "", !isLoading else {
            return
        }
        
        fetchContactQuestions()
    }
    
    
    func refreshContactQuestions() {
        pagination = nil
        fetchContactQuestions()
    }
    
//    func addQuestion(content: String) {
//        guard let questionId else { return }
//        
//        apiService.addQuestion(questionId: questionId, createQuestion: CreateContactQuestion(content: content)) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let newMessage):
//                    print("succes")
//                    print(newMessage)
//                    self?.messages.append(newMessage)
//                    self?.newMessageContent = ""
//                case .failure(let error):
//                    self?.isFailure = true
//                    print("Error adding message: \(error)")
//                }
//            }
//        }
//    }
}
