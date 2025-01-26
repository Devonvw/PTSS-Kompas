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
final class PasswordForgotVerifyViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    
    private let apiService = UserService()
    private let validator = PasswordForgetVerifyValidator()
    
    func request(body: ForgotPasswordVerify, onSuccess: () -> Void) async {
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(body)
        } catch let validationError as PasswordForgetVerifyValidator.ValidatorError {
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
            try await apiService.verifyRequestPasswordReset(body: body)
            
            self.isLoading = false
            onSuccess()
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


extension PasswordForgotVerifyViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension PasswordForgotVerifyViewModel.FormError {
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

