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
final class RegisterPinViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    @Published var pin: String = ""
    private var toastManager = ToastManager.shared
    
    private let apiService = UserService()
    private let validator = RegisterPinValidator()
    
    func createPin(onSuccess: () -> Void) async {
        isLoading = true
        isAlertFailure = false
        
        let body: PinCreate = .init(pin: pin)
        
        do {
            try validator.validate(body)
        } catch let validationError as RegisterPinValidator.ValidatorError {
            await MainActor.run {
                self.isLoading = false
                self.error = .validation(error: validationError)
            }
            print(validationError)
            return
        } catch {
            self.isLoading = false
            self.isAlertFailure = true
            self.error = .system(error: error)
            print(error)
            return
        }
        
        do {
            _ = try await apiService.createPin(body: body)
            AuthManager.shared.setLoggedIn()
            
            await MainActor.run {
                self.isLoading = false
                print("Success")
                toastManager.toast = Toast(style: .success, message: "Jouw pincode is aangemaakt!")
                onSuccess()
                
            }
        } catch let error as NetworkError {
            await MainActor.run {
                self.isLoading = false
                self.isAlertFailure = true
                self.error = .networking(error: error)
                print("Error creating pin: \(error)")
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


extension RegisterPinViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension RegisterPinViewModel.FormError {
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



