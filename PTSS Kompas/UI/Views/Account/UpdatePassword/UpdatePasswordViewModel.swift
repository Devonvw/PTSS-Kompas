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
    @Published var currentPassword: String = "Password1"
    @Published var newPassword: String = "Password1#"
    @Published var repeatNewPassword: String = "Password1#"

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
            _ = try await apiService.updatePassword(body: passwordUpdate)
            
            await MainActor.run {
                self.isLoading = false
                self.currentPassword = ""
                self.newPassword = ""
                self.repeatNewPassword = ""
                onSuccess()
                toastManager.toast = Toast(style: .success, message: "Jouw wachtwoord is succesvol gewijzigd")
            }
        } catch let error as NetworkError {
            await MainActor.run {
                self.isLoading = false
                self.isAlertFailure = true
                self.error = .networking(error: error)
                print("Error updating password: \(error)")
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

