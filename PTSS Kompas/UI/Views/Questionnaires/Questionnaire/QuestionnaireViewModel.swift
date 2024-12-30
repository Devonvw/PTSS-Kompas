//
//  QuestionnaireViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class QuestionnaireViewModel: ObservableObject {
    @Published var explanation: QuestionnaireExplanation?
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    
    private let apiService = QuestionnaireService()
    
    func fetchQuestionnaire(id: String) async {
        isLoading = true
        isFailure = false
        
        do {
            let data = try await apiService.getQuestionnaireExplanation(questionnaireId: id)
            
            await MainActor.run {
                self.explanation = data
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isFailure = true
                self.isLoading = false
                self.explanation = nil
            }
            print("Error: \(error)")
        }
    }

}
