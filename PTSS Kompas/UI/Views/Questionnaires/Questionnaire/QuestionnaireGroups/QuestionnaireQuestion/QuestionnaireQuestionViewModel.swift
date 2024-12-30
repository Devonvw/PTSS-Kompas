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
    @Published var question: QuestionnaireQuestion?
    @Published var questionOrder: Int = 1
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    @Published var isSaving: Bool = false
    @Published var isFailureSaving: Bool = false
    
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

    func saveAnswers(questionnaireId: String, groupId: Int) async {
        isSaving = true
        isFailureSaving = false

        var answers: [SaveQuestionAnswerRequest] = []

        for subQuestion in question?.subQuestions ?? [] {
            guard let answer = subQuestion.answer else {
                await MainActor.run {
                    self.isSaving = false
                    self.isFailureSaving = true
                }
                return
            }
            answers.append(SaveQuestionAnswerRequest(id: subQuestion.id, answer: answer))
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
            await MainActor.run {
                self.isSaving = false
            }
        } catch {
            await MainActor.run {
                self.isSaving = false
                self.isFailureSaving = true
            }
            print("Error: \(error)")
        }
    }

    
    func nextQuestion(questionnaireId: String, groupId: Int, onSuccess: () -> Void) async {
        if (isLastQuestion) { return }
        
        guard let currentQuestion = question,
              let currentIndex = questions.firstIndex(where: { $0.id == currentQuestion.id })
        else {
            return
        }
        
        await saveAnswers(questionnaireId: questionnaireId, groupId: groupId)
        onSuccess()
        
        let nextIndex = currentIndex + 1
        if nextIndex < questions.count {
            question = questions[nextIndex]
            questionOrder += 1
        }
    }
    
    func backQuestion(questionnaireId: String, groupId: Int) {
        if (isFirstQuestion) { return }
        
        guard let currentQuestion = question,
              let currentIndex = questions.firstIndex(where: { $0.id == currentQuestion.id })
        else {
            return
        }
        
//        saveAnswers(questionnaireId: questionnaireId, groupId: groupId)  { [weak self] result in
//            DispatchQueue.main.async {
//                self?.isSaving = false
//                switch result {
//                case .success(_):
//                    let backIndex = currentIndex - 1
//                    if backIndex >= 0 {
//                        self?.question = self?.questions[backIndex]
//                        self?.questionOrder -= 1
//                    }
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            }
//        }
        
        let backIndex = currentIndex - 1
        if backIndex >= 0 {
            question = questions[backIndex]
            questionOrder -= 1
        }
    }
    
    var isLastQuestion: Bool {
        return questions.last?.id == question?.id
    }
    
    var isFirstQuestion: Bool {
        return questions.first?.id == question?.id
    }
}
