//
//  MembersViewModel.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 30/12/2024.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class MembersViewModel: ObservableObject {
    @Published var members: [User] = []
    @Published var isLoading: Bool = false
    @Published var isFailure: Bool = false
    
    private let apiService = UserService()
    
    func fetchMembers() async {
        isLoading = true
        isFailure = false
        
        do {
            let data = try await apiService.getMembersOfCurrentUsersGroup()
            
            await MainActor.run {
                self.members = data
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isFailure = true
                self.isLoading = false
                self.members = []
            }
            print("Error: \(error)")
        }
    }

}
