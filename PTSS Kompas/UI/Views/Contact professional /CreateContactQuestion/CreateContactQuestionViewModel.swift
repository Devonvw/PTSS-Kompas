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
    @Published var isFailure: Bool = false
    @Published var newQuestionSubject: String = ""
    @Published var newQuestionContent: String = ""
    
    private let apiService = ContactService()
    private let validator = CreateContactQuestionValidator()
    
    func addQuestion() {
        let createQuestion = CreateContactQuestion(subject: newQuestionSubject, content: newQuestionContent)
        
        do {
            try validator.validate(createQuestion)
            
            apiService.addQuestion(createQuestion: createQuestion) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let newQuestion):
                                            print("succes")
                                            print(newQuestion)
                        //                    self?.messages.append(newMessage)
                        self?.newQuestionSubject = ""
                        self?.newQuestionContent = ""
                    case .failure(let error):
                        self?.isFailure = true
                        print("Error adding message: \(error)")
                    }
                }
            }
        } catch {
            print(error)
        }
        
        
       
    }
}

