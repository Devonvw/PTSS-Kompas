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
final class CreateToolCommentViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    @Published var newCommentContent: String = ""
    
    private let apiService = ToolService()
    private let validator = CreateToolCommentValidator()
    private var toastManager = ToastManager.shared
    
    func addComment(toolId: String, onSuccess: (_ comment: ToolComment) -> Void) async {
        let createComment = CreateToolComment(content: newCommentContent)
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(createComment)
        } catch let validationError as CreateToolCommentValidator.CreateValidatorError {
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
            let newComment = try await apiService.addToolComment(toolId: toolId, comment: createComment)
            
            isLoading = false
            newCommentContent = ""
            onSuccess(newComment)
            toastManager.toast = Toast(style: .success, message: "Jouw opmerking is succesvol geplaatst!")
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


extension CreateToolCommentViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension CreateToolCommentViewModel.FormError {
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

