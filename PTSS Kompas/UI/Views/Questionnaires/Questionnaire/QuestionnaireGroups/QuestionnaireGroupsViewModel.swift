//
//  QuestionnaireGroupsViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import Foundation
import Combine
import SwiftUI

final class QuestionnaireGroupsViewModel: ObservableObject {
    @Published var groups: [QuestionnaireGroup] = []
    @Published var completedGroups: Int = 0
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    
    private let apiService = QuestionnaireService()
    
    func fetchQuestionnaireGroups(questionnaireId: String) {
        isLoading = true
        isFailure = false

        apiService.getQuestionnaireGroups(questionnaireId: questionnaireId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.groups = data
                    self?.completedGroups = data.filter { $0.isFinished }.count
                case .failure(let error):
                    self?.isFailure = true
                    print("Error: \(error)")
                }
            }
        }
    }
}
