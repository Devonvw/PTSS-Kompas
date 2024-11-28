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
    @Published var question: QuestionnaireQuestion? = QuestionnaireQuestion.example
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    
    private let apiService = QuestionnaireService()
    
    func fetchQuestionnaireQuestions(questionnaireId: String, groupId: String) {
        isLoading = true
        isFailure = false
        
        apiService.getQuestionnaireQuestions(questionnaireId: questionnaireId, groupId: groupId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.questions = data
                    self?.question = data.first
                case .failure(let error):
                    self?.isFailure = true
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func nextQuestion() {
        if (isLastQuestion) { return }
        
        guard let currentQuestion = question,
              let currentIndex = questions.firstIndex(where: { $0.id == currentQuestion.id })
        else {
            return
        }
        
        let nextIndex = currentIndex + 1
        if nextIndex < questions.count {
            question = questions[nextIndex]
        }
    }
    
    func backQuestion() {
        if (isFirstQuestion) { return }
        
        guard let currentQuestion = question,
              let currentIndex = questions.firstIndex(where: { $0.id == currentQuestion.id })
        else {
            return
        }
        
        let backIndex = currentIndex - 1
        if backIndex >= 0 {
            question = questions[backIndex]
        }
    }
    
    var isLastQuestion: Bool {
        return questions.last?.id == question?.id
    }
    
    var isFirstQuestion: Bool {
        return questions.first?.id == question?.id
    }
}
