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
final class InviteMemberViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isAlertFailure: Bool = false
    @Published private(set) var error: FormError?
    @Published var newMemberEmail: String = ""
    
    private let apiService = UserService()
    private let validator = InviteMemberValidator()
    private var toastManager = ToastManager.shared
    
    func inviteMember(onSuccess: () -> Void) async {
        let userInviteCreate = UserInviteCreate(email: newMemberEmail)
        isLoading = true
        isAlertFailure = false
        
        do {
            try validator.validate(userInviteCreate)
        } catch let validationError as InviteMemberValidator.CreateValidatorError {
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
            _ = try await apiService.inviteUser(body: userInviteCreate)
            
            isLoading = false
            newMemberEmail = ""
            onSuccess()
            toastManager.toast = Toast(style: .success, message: "De persoon is succesvol uitgenodigd")
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


extension InviteMemberViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension InviteMemberViewModel.FormError {
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

