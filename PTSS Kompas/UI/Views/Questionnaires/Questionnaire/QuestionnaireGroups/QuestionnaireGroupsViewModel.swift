//
//  QuestionnaireGroupsViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/11/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class QuestionnaireGroupsViewModel: ObservableObject {
    @Published var groups: [QuestionnaireGroup] = []
    @Published var completedGroups: Int = 0
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    @Published var isLoadingFinish: Bool = false
    @Published var isFailureFinish: Bool = false
    @Published var showFinishAlert: Bool = false
    private var toastManager = ToastManager.shared
    private let apiService = QuestionnaireService()
    
    var questionnaireIsFinished: Bool {
        return groups.count == 0 ? false : completedGroups == groups.count
    }
    
    func fetchQuestionnaireGroups(questionnaireId: String) async {
        isLoading = true
        isFailure = false
        
        do {
            let data = try await apiService.getQuestionnaireGroups(questionnaireId: questionnaireId)
                self.groups = data
                self.completedGroups = data.filter { $0.isFinished }.count
                self.isLoading = false
        } catch {
                self.isFailure = true
                self.isLoading = false
            print("Error: \(error)")
        }
    }
    
    func finishQuestionnaire(questionnaireId: String, onSuccess: () -> Void) async {
        isLoadingFinish = true
        isFailureFinish = false
        
        do {
            try await apiService.finishQuestionnaire(questionnaireId: questionnaireId)
            self.isLoadingFinish = false
            
            
            onSuccess()
            toastManager.toast = Toast(style: .success, message: "De vragenlijst is succesvol afgerond")
        } catch {
            self.isFailureFinish = true
            self.isLoadingFinish = false
            print("Error: \(error)")
        }
    }
    
}
