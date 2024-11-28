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
    @Published var searchText = ""

    private let apiService = QuestionnaireService()
    
    init() {
        fetchQuestionnaires()
    }
    
    var filteredQuestionaires: [Questionnaire] {
        if searchText.isEmpty {
            return questionnaires
        } else {
            return questionnaires.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func fetchQuestionnaires() {
        isLoading = true
        isFailure = false
        apiService.getQuestionnaires { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.questionnaires = data
                case .failure(let error):
                    self?.isFailure = true
                    print("Error: \(error)")
                }
            }
        }
    }
}
