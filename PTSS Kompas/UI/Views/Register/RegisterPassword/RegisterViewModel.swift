//
//  RegisterNameViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 15/12/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    @Published var passwordValidation: PasswordValidationResult?
    private var toastManager = ToastManager.shared

    private let apiService = UserService()
    private let validator = RegisterValidator()
    
    func validatePassword(password: String) async {
        passwordValidation = PasswordValidator.validate(password: password)
    }
    
    func register(body: UserRegister, onSuccess: () -> Void) async {
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(body)
        } catch let validationError as RegisterValidator.ValidatorError {
            await MainActor.run {
                self.isLoading = false
                self.error = .validation(error: validationError)
            }
            print(validationError)
            return
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.isAlertFailure = true
                self.error = .system(error: error)
            }
            print(error)
            return
        }
        
        do {
            try await AuthManager.shared.register(body)
//            _ = KeychainManager.shared.saveToken(response.accessToken, for: "accessToken")
//            _ = KeychainManager.shared.saveToken(response.refreshToken, for: "refreshToken")

            await MainActor.run {
                self.isLoading = false
                print("Success")
                toastManager.toast = Toast(style: .success, message: "Jouw wachtwoord is aangemaakt!")
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
                self.error = .system(error: error)
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

