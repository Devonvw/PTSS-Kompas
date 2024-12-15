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
    
    func fetchQuestionnaireGroups(questionnaireId: String) async {
        isLoading = true
        isFailure = false

        do {
            let data = try await apiService.getQuestionnaireGroups(questionnaireId: questionnaireId)
            await MainActor.run {
                self.groups = data
                self.completedGroups = data.filter { $0.isFinished }.count
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

}
