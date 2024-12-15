//
//  RegisterNameViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 15/12/2024.
//

import Foundation
import Combine
import SwiftUI

final class RegisterViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    @Published var passwordValidation: PasswordValidationResult?
    
    private let apiService = UserService()
    private let validator = RegisterVerifyValidator()
    
    func validatePassword(password: String) async {
        passwordValidation = PasswordValidator.validate(password: password)
    }
    
    func verifyRegister(body: UserInviteVerify, onSuccess: () -> Void) async {
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(body)
        } catch let validationError as RegisterVerifyValidator.ValidatorError {
            await MainActor.run {
                self.isLoading = false
                self.error = .validation(error: validationError)
            }
            print(validationError)
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.isAlertFailure = true
                self.error = .system(error: error)
            }
            print(error)
        }
        
        do {
            try await apiService.verifyUserInvitation(body: body)
            
            await MainActor.run {
                self.isLoading = false
                print("Success")
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


extension RegisterViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension RegisterViewModel.FormError {
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

