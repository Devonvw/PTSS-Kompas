//
//  QuestionnaireQuestionViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import Foundation
import Combine
import SwiftUI

final class QuestionnaireQuestionViewModel: ObservableObject {
    @Published var questions: [QuestionnaireQuestion] = []
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    
    private let apiService = QuestionnaireService()
    
    func getQuestionnaireQuestions(questionnaireId: String, groupId: String) {
        isLoading = true
        apiService.getQuestionnaireQuestions(questionnaireId: questionnaireId, groupId: groupId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.questions = data
                case .failure(let error):
                    self?.isFailure = true
                    print("Error: \(error)")
                }
            }
        }
    }
}
