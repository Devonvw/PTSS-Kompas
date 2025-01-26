//
//  RegisterVerifyViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 15/12/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class RegisterVerifyViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    
    private let apiService = UserService()
    private let validator = RegisterVerifyValidator()
    
    func verifyRegister(body: UserInviteVerify, onSuccess: () -> Void) async {
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(body)
        } catch let validationError as RegisterVerifyValidator.ValidatorError {
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
            try await apiService.verifyUserInvitation(body: body)
            
            isLoading = false
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


extension RegisterVerifyViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension RegisterVerifyViewModel.FormError {
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

