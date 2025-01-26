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
final class UpdatePasswordViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var repeatNewPassword: String = ""
    
    private let apiService = UserService()
    private let validator = UpdatePasswordValidator()
    private var toastManager = ToastManager.shared
    
    func updatePassword(onSuccess: () -> Void) async {
        let passwordUpdate = PasswordUpdate(currentPassword: currentPassword, newPassword: newPassword, repeatNewPassword: repeatNewPassword)
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(passwordUpdate)
        } catch let validationError as UpdatePasswordValidator.ValidatorError {
            isLoading = false
            error = .validation(error: validationError)
            return
        } catch {
            isLoading = false
            isAlertFailure = true
            self.error = .system(error: error)
            return
        }
        
        do {
            _ = try await apiService.updatePassword(body: passwordUpdate)
            
            isLoading = false
            currentPassword = ""
            newPassword = ""
            repeatNewPassword = ""
            onSuccess()
            toastManager.toast = Toast(style: .success, message: "Jouw wachtwoord is succesvol gewijzigd")
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


extension UpdatePasswordViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension UpdatePasswordViewModel.FormError {
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

