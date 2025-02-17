//
//  QuestionnairesController.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 25/11/2024.
//
import Foundation
import Combine
import SwiftUI

@MainActor
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
        Task {
            await fetchQuestionnaires()
        }
        debounceSearchText()
    }
    
    private func debounceSearchText() {
        searchTextSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.debouncedSearchText = query
                Task {
                    await self?.refreshQuestionnaires()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchQuestionnaires() async {
        isLoading = true
        isFailure = false
        
        if pagination?.nextCursor == nil || pagination?.nextCursor == "" {
            questionnaires = []
        }
        
        do {
            let data = try await apiService.getQuestionnaires(cursor: pagination?.nextCursor, search: debouncedSearchText)
            
            questionnaires.append(contentsOf: data.data)
            pagination = data.pagination
            isLoading = false
        } catch {
            isFailure = true
            isLoading = false
        }
    }
    
    
    func fetchMoreQuestionnaires(questionnaire: Questionnaire) async {
        guard let lastQuestionnaire = questionnaires.last, lastQuestionnaire.id == questionnaire.id else {
            return
        }
        
        guard pagination?.nextCursor != nil, pagination?.nextCursor != "", !isLoading else {
            return
        }
        
        await fetchQuestionnaires()
    }
    
    func refreshQuestionnaires() async {
        pagination = nil
        await fetchQuestionnaires()
    }
}
