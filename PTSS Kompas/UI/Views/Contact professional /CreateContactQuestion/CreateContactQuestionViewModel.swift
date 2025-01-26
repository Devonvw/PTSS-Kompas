//
//  CreateContactQuestionViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//
import Foundation
import Combine
import SwiftUI

@MainActor
final class CreateContactQuestionViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    @Published var newQuestionSubject: String = ""
    @Published var newQuestionContent: String = ""
    
    private let apiService = ContactService()
    private let validator = CreateContactQuestionValidator()
    private var toastManager = ToastManager.shared
    
    func addQuestion(onSuccess: () -> Void) async {
        let createQuestion = CreateContactQuestion(subject: newQuestionSubject, content: newQuestionContent)
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(createQuestion)
        } catch let validationError as CreateContactQuestionValidator.CreateValidatorError {
            isLoading = false
            self.error = .validation(error: validationError)
            return
        } catch {
            isLoading = false
            isAlertFailure = true
            self.error = .system(error: error)
            return
        }
        
        do {
            _ = try await apiService.addQuestion(createQuestion: createQuestion)
            
            isLoading = false
            newQuestionSubject = ""
            newQuestionContent = ""
            onSuccess()
            toastManager.toast = Toast(style: .success, message: "De nieuwe vraag is succesvol toegevoegd")
        } catch let error as NetworkError {
            isLoading = false
            isAlertFailure = true
            self.error = .networking(error: error)
        } catch {
            isAlertFailure = true
            isLoading = false
        }
        
    }
    
}


extension CreateContactQuestionViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension CreateContactQuestionViewModel.FormError {
    var errorDescription: String? {
        switch self {
        case .networking(let err),
                .validation(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

