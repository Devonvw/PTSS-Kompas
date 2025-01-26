//
//  LoginViewController.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 19/11/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class LoginPinViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    @Published var pin: String = ""
    
    private let apiService = UserService()
    private let validator = LoginPinValidator()
    
    func loginPin(onSuccess: () -> Void) async {
        isLoading = true
        isAlertFailure = false
        
        let body: PinLogin = .init(pin: pin)
        
        do {
            try validator.validate(body)
        } catch let validationError as LoginPinValidator.ValidatorError {
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
            try await AuthManager.shared.pinLogin(body)
            
            isLoading = false
            onSuccess()
        } catch let error as NetworkError {
            isLoading = false
            isAlertFailure = true
            self.error = .networking(error: error)
        } catch {
            isAlertFailure = true
            isLoading = false
            self.error = .system(error: error)
        }
    }
}

extension LoginPinViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension LoginPinViewModel.FormError {
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

