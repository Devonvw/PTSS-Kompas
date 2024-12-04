//
//  QuestionnairesController.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 25/11/2024.
//
import Foundation
import Combine
import SwiftUI

final class QuestionnairesViewModel: ObservableObject {
    @Published var questionnaires: [Questionnaire] = []
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
    
    private let apiService = QuestionnaireService()
    
    init() {
        debounceSearchText()
        fetchQuestionnaires()
    }
    
    private func debounceSearchText() {
        searchTextSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.debouncedSearchText = query
                self?.refreshQuestionnaires()
            }
            .store(in: &cancellables)
    }
    
    func fetchQuestionnaires() {
        isLoading = true
        isFailure = false
        if (pagination?.nextCursor == nil || pagination?.nextCursor == "") {
            questionnaires = []
        }
        
        apiService.getQuestionnaires(cursor: pagination?.nextCursor, search: debouncedSearchText) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                   self?.questionnaires.append(contentsOf: data.data)
                    self?.pagination = data.pagination
                case .failure(let error):
                    self?.isFailure = true
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func fetchMoreQuestionnaires(questionnaire: Questionnaire) {
        guard let lastQuestionnaire = questionnaires.last, lastQuestionnaire.id == questionnaire.id else {
            return
        }
        
        guard pagination?.nextCursor != nil, pagination?.nextCursor != "", !isLoading else {
            return
        }
        
        fetchQuestionnaires()
    }
    
    func refreshQuestionnaires() {
        pagination = nil
        fetchQuestionnaires()
    }
}
