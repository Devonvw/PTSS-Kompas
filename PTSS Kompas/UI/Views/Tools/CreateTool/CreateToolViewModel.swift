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
final class CreateToolViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isLoadingCategories: Bool = false
    @Published var isFailureCategories: Bool = false

    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    @Published var newToolName: String = ""
    @Published var newToolDescription: String = ""
    @Published var selectedCategories: Set<ToolCategory> = []
    @Published var categories: [ToolCategory] = ToolCategory.examples

    private let apiService = ToolService()
    private let validator = CreateToolValidator()
    
    func addTool(onSuccess: (_ tool: Tool) -> Void) async {
        let createTool = CreateTool(name: newToolName, description: newToolDescription, category: categories.map{$0.category})
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(createTool)
        } catch let validationError as CreateToolValidator.CreateValidatorError {
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
            let newComment = try await apiService.createTool(tool: createTool)
            
            await MainActor.run {
                self.isLoading = false
                self.newToolName = ""
                self.newToolDescription = ""
                print("Success")
                print(newComment)
                onSuccess(newComment)
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
    
    func fetchToolCategories() async {
        isLoading = true
        await MainActor.run { self.isFailureCategories = false }
        
        do {
            let data = try await apiService.getTools(search: nil)
            
            await MainActor.run {
                self.categories = data
                self.isLoadingCategories = false
            }
        } catch {
            await MainActor.run {
                self.isFailureCategories = true
                self.isLoadingCategories = false
            }
            print("Error: \(error)")
        }
    }
    
}


extension CreateToolViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension CreateToolViewModel.FormError {
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

