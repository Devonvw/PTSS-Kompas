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
final class UpdatePinViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    @Published var currentPin: String = ""
    @Published var newPin: String = ""
    
    private let apiService = UserService()
    private let validator = UpdatePinValidator()
    private var toastManager = ToastManager.shared
    
    func updatePin(onSuccess: () -> Void) async {
        let pinUpdate = PinUpdate(currentPin: currentPin, newPin: newPin)
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(pinUpdate)
        } catch let validationError as UpdatePinValidator.ValidatorError {
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
            _ = try await apiService.updatePin(body: pinUpdate)
            
            isLoading = false
            currentPin = ""
            newPin = ""
            onSuccess()
            toastManager.toast = Toast(style: .success, message: "Jouw pincode is succesvol gewijzigd")
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

extension UpdatePinViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension UpdatePinViewModel.FormError {
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

