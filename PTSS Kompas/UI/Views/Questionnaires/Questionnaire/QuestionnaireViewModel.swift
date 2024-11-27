//
//  QuestionnaireViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import Foundation
import Combine
import SwiftUI

final class QuestionnaireViewModel: ObservableObject {
    @Published var questionnaireExplanation: QuestionnaireExplanation?
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    
    private let apiService = QuestionnaireService()
    
    func fetchQuestionnaire(id: String) {
        isLoading = true
        apiService.getQuestionnaireExplanation(questionnaireId: id) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.questionnaireExplanation = data
                case .failure(let error):
                    self?.isFailure = true
                    print("Error: \(error)")
                }
            }
        }
    }
}
