//
//  LoginViewController.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 19/11/2024.
//

import Foundation
import Combine
import SwiftUI

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
            let response = try await apiService.loginPin(body: body)
            _ = KeychainManager.shared.saveToken(response.accessToken, for: "accessToken")
            _ = KeychainManager.shared.saveToken(response.refreshToken, for: "refreshToken")

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
                print("Error login: \(error)")
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
