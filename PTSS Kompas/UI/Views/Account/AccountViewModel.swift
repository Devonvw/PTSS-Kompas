//
//  ProfileViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 30/12/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class AccountViewModel: ObservableObject {
    @Published var members: [User] = []
    @Published var allMembers: [User] = []
    @Published var patient: User?
    @Published var primaryCaregiver: User?
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    @Published var isLoadingDelete: Bool = false
    @Published var isFailureDelete: Bool = false
    @Published var showDeleteAlert = false
    @Published var showUpdateAlert = false
    @Published var showInviteAlert = false
    @Published var showUpdatePinAlert = false
    @Published var showUpdatePasswordAlert = false
    
    @Published var selectedMember: User?
    
    
    private let apiService = UserService()
    private var toastManager = ToastManager.shared
    
    func fetchMembers() async {
        isLoading = true
        isFailure = false
        
        do {
            let data = try await apiService.getMembersOfCurrentUsersGroup()
            
            patient = data.first { $0.role == Role.Patient}
            primaryCaregiver = data.first { $0.role == Role.PrimaryCaregiver }
            members = data.filter { $0.role != Role.PrimaryCaregiver && $0.role != Role.Patient }
            allMembers = data
            isLoading = false
        } catch {
            isFailure = true
            isLoading = false
            patient = nil
            primaryCaregiver = nil
            members = []
            allMembers = []
            
        }
    }
    
    func deleteMember(_ member: User) async {
        isLoadingDelete = true
        isFailureDelete = false
        
        do {
            _ = try await apiService.deleteUserFromGroup(userId: member.id)
            
            members = members.filter { $0.id != member.id }
            toastManager.toast = Toast(style: .success, message: "De persoon is succesvol verwijderd")
            
            isLoadingDelete = false
        } catch {
            isFailureDelete = true
            isLoadingDelete = false
        }
    }
}
