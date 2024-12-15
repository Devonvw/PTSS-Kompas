//
//  CreateContactQuestionViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//
import Foundation
import Combine
import SwiftUI

final class CreateContactQuestionViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    @Published var newQuestionSubject: String = ""
    @Published var newQuestionContent: String = ""
    
    private let apiService = ContactService()
    private let validator = CreateContactQuestionValidator()
    
    func addQuestion(onSuccess: () -> Void) async {
        let createQuestion = CreateContactQuestion(subject: newQuestionSubject, content: newQuestionContent)
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(createQuestion)
        } catch let validationError as CreateContactQuestionValidator.CreateValidatorError {
            await MainActor.run {
                self.isLoading = false
                self.error = .validation(error: validationError)
            }
            return
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.isAlertFailure = true
                self.error = .system(error: error)
            }
            return
        }
        
        do {
            let newQuestion = try await apiService.addQuestion(createQuestion: createQuestion)
            
            await MainActor.run {
                self.isLoading = false
                self.newQuestionSubject = ""
                self.newQuestionContent = ""
                print("Success")
                print(newQuestion)
                onSuccess()
            }
        } catch let error as NetworkError {
            await MainActor.run {
                self.isLoading = false
                self.isAlertFailure = true
                self.error = .networking(error: error)
                print("Error adding question: \(error)")
            }
        } catch {
            await MainActor.run {
                self.isAlertFailure = true
                self.isLoading = false
            }
            print("Error: \(error)")
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

