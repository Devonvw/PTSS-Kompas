//
//  QuestionnaireQuestionViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class QuestionnaireQuestionViewModel: ObservableObject {
    @Published var questions: [QuestionnaireQuestion] = []
    @Published var question: QuestionnaireQuestion? {
        didSet {
            updateSubQuestionsAnsweredState()
        }
    }
    @Published var areAllSubQuestionsAnsweredState: Bool = false
    @Published var questionOrder: Int = 1
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    @Published var isSaving: Bool = false
    @Published var isFailureSaving: Bool = false
    private var toastManager = ToastManager.shared

    
    private let apiService = QuestionnaireService()
    
    func fetchQuestionnaireQuestions(questionnaireId: String, groupId: Int) async {
        isLoading = true
        isFailure = false
        
        do {
            let data = try await apiService.getQuestionnaireQuestions(questionnaireId: questionnaireId, groupId: groupId)
            await MainActor.run {
                self.questions = data
                self.question = data.first
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isFailure = true
                self.isLoading = false
            }
            print("Error: \(error)")
        }
    }
    
    func saveAnswers(questionnaireId: String, groupId: Int) async throws {
        isSaving = true
        isFailureSaving = false
        
        var answers: [SaveQuestionAnswerRequest] = []
        
        for subQuestion in question?.subQuestions ?? [] {
            if let answer = subQuestion.answer {
                answers.append(SaveQuestionAnswerRequest(id: subQuestion.id, answer: answer))
            }
        }
        
        guard let questionId = question?.id else {
            await MainActor.run {
                self.isSaving = false
            }
            return
        }
        
        do {
            try await apiService.saveQuestionAnswers(
                questionnaireId: questionnaireId,
                groupId: groupId,
                questionId: questionId,
                answers: answers
            )
        
            self.isSaving = false
        } catch {
            self.isSaving = false
            self.isFailureSaving = true
//            toastManager.toast = Toast(style: .error, message: "Het is niet gelukt om de antwoorden op te slaan. Probeer het opnieuw.")
            print("Error: \(error)")
            throw error
        }
    }
    
    
    func nextQuestion(questionnaireId: String, groupId: Int, onSuccess: () -> Void) async {
        do {
            try await saveAnswers(questionnaireId: questionnaireId, groupId: groupId)
            onSuccess()
            
            if (isLastQuestion) { return }
            
            guard let currentQuestion = question,
                  let currentIndex = questions.firstIndex(where: { $0.id == currentQuestion.id })
            else {
                return
            }
            
            
            let nextIndex = currentIndex + 1
            if nextIndex < questions.count {
                if var currentQuestion = question {
                    currentQuestion.isFinished = true
                    questions[currentIndex] = currentQuestion
                }
                
                question = questions[nextIndex]
                questionOrder += 1
            }
        } catch {
            
        }
    }
    
    func backQuestion(questionnaireId: String, groupId: Int) async {
        if (isFirstQuestion) { return }

        do {
            try await saveAnswers(questionnaireId: questionnaireId, groupId: groupId)
            
            guard let currentQuestion = question,
                  let currentIndex = questions.firstIndex(where: { $0.id == currentQuestion.id })
            else {
                return
            }
            
            let backIndex = currentIndex - 1
            if backIndex >= 0 {
                if var currentQuestion = question {
                    currentQuestion.isFinished = true
                    questions[currentIndex] = currentQuestion
                }
                
                question = questions[backIndex]
                questionOrder -= 1
            }
        } catch {
            print(error)
        }
    }
    
    var isLastQuestion: Bool {
        return questions.last?.id == question?.id
    }
    
    var isFirstQuestion: Bool {
        return questions.first?.id == question?.id
    }
    
    func updateSubQuestionsAnsweredState() {
        areAllSubQuestionsAnsweredState = question?.subQuestions.allSatisfy { $0.answer != nil } ?? false
    }
}
