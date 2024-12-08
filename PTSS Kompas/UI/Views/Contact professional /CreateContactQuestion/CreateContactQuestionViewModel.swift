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
    
    func addQuestion(onSuccess: @escaping () -> Void) {
        let createQuestion = CreateContactQuestion(subject: newQuestionSubject, content: newQuestionContent)
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(createQuestion)
            
            apiService.addQuestion(createQuestion: createQuestion) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false

                    switch result {
                    case .success(let newQuestion):
                        print("succes")
                        print(newQuestion)
                        //                    self?.messages.append(newMessage)
                        self?.newQuestionSubject = ""
                        self?.newQuestionContent = ""
                        onSuccess()
                    case .failure(let error):
                        self?.isAlertFailure = true
                        self?.error = .networking(error: error)

                        print("Error adding message: \(error)")
                    }
                }
            }
        } catch {
            isLoading = false
            
            switch error {
            case is CreateContactQuestionValidator.CreateValidatorError:
                self.error = .validation(error: error as! CreateContactQuestionValidator.CreateValidatorError)
            default:
                isAlertFailure = true
                self.error = .system(error: error)
            }
            
            print(error)
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

