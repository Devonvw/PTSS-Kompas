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
    @Published var selectedMember: User?

    
    private let apiService = UserService()
    
    func fetchMembers() async {
        isLoading = true
        isFailure = false
        
        do {
            let data = try await apiService.getMembersOfCurrentUsersGroup()
            
            await MainActor.run {
                self.patient = data.first { $0.role == Role.Patient}
                self.primaryCaregiver = data.first { $0.role == Role.PrimaryCaregiver }
                self.members = data.filter { $0.role != Role.PrimaryCaregiver && $0.role != Role.Patient }
                self.allMembers = data
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isFailure = true
                self.isLoading = false
                self.patient = nil
                self.primaryCaregiver = nil
                self.members = []
                self.allMembers = []

            }
            print("Error: \(error)")
        }
    }
    
    func deleteMember(_ member: User) async {
        isLoadingDelete = true
        isFailureDelete = false
        
        do {    
            _ = try await apiService.deleteUserFromGroup(userId: member.id)
            
            self.members = self.members.filter { $0.id != member.id }
            self.isLoadingDelete = false
        } catch {
            self.isFailureDelete = true
            self.isLoadingDelete = false
            print("Error: \(error)")
        }
    }
}
