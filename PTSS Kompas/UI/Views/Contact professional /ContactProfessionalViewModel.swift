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
        Task {
            await fetchContactQuestions()
        }
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
    
    func fetchContactQuestions() async {
        isLoading = true
        isFailure = false
        
        if pagination?.nextCursor == nil || pagination?.nextCursor == "" {
            questions = []
        }
        
        do {
            let data = try await apiService.getContactQuestions(cursor: pagination?.nextCursor, search: debouncedSearchText)
            
            await MainActor.run {
                questions.append(contentsOf: data.data)
                pagination = data.pagination
                isLoading = false
            }
        } catch {
            await MainActor.run {
                isFailure = true
                isLoading = false
            }
            print("Error: \(error)")
        }
    }

    
    func fetchMoreContactQuestions(question: ContactQuestion) async {
        guard let lastQuestion = questions.last, lastQuestion.id == question.id else {
            return
        }
        
        guard pagination?.nextCursor != nil, pagination?.nextCursor != "", !isLoading else {
            return
        }
        
        await fetchContactQuestions()
    }
    
    
    func refreshContactQuestions() async {
        pagination = nil
        await fetchContactQuestions()
    }
}
