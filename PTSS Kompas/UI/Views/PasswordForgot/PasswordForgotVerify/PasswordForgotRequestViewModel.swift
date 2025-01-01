//
//  PasswordForgotRequestViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 01/01/2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class PasswordForgotRequestViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    
    private let apiService = UserService()
    private let validator = PasswordForgetRequestValidator()
    
    func request(body: ForgotPassword, onSuccess: () -> Void) async {
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(body)
        } catch let validationError as PasswordForgetRequestValidator.ValidatorError {
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
            try await apiService.requestPasswordReset(body: body)
            
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
                print("Error password forget request: \(error)")
            }
        } catch {
            await MainActor.run {
                self.isAlertFailure = true
                self.isLoading = false
            }
            print("Error 12: \(error)")
        }
        
    }
    
}


extension PasswordForgotRequestViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension PasswordForgotRequestViewModel.FormError {
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

