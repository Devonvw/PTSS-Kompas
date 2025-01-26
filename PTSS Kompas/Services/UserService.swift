//
//  UserService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

import Foundation

final class UserService {
    let baseURL = "users/"
    let groupsBaseURL = "groups/"

    func inviteUser(body: UserInviteCreate) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "invite",
            method: .POST,
            body: body,
            responseType: VoidResponse.self
        )
    }
    
    func verifyUserInvitation(body: UserInviteVerify) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "invite/verify",
            method: .POST,
            body: body,
            responseType: VoidResponse.self
        )
    }
    
    func register(body: UserRegister) async throws -> AuthResponse {
        return try await NetworkManager.shared.request(
            endpoint: baseURL + "register",
            method: .POST,
            body: body,
            responseType: AuthResponse.self
        )
    }
    
    func login(body: Login) async throws -> AuthResponse {
        return try await NetworkManager.shared.request(
            endpoint: baseURL + "login",
            method: .POST,
            body: body,
            responseType: AuthResponse.self
        )
    }
    
    func loginPin(body: PinLogin) async throws -> AuthResponse {
        return try await NetworkManager.shared.request(
            endpoint: baseURL + "login/pin",
            method: .POST,
            body: body,
            responseType: AuthResponse.self
        )
    }
    
    func getCurrentUser() async throws -> User {
        return try await NetworkManager.shared.request(
            endpoint: baseURL + "me",
            method: .GET,
            responseType: User.self
        )
    }
    
    func deleteUserFromGroup(userId: String) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "\(userId)",
            method: .DELETE,
            responseType: VoidResponse.self
        )
    }
    
    func updatePassword(body: PasswordUpdate) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "me/password",
            method: .PUT,
            body: body,
            responseType: VoidResponse.self
        )
    }
    
    func createPin(body: PinCreate) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "me/pin",
            method: .POST,
            body: body,
            responseType: VoidResponse.self
        )
    }
    
    func updatePin(body: PinUpdate) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "me/pin",
            method: .PUT,
            body: body,
            responseType: VoidResponse.self
        )
    }
    
    func getMembersOfCurrentUsersGroup() async throws -> [User] {
        return try await NetworkManager.shared.request(
            endpoint: groupsBaseURL + "members",
            method: .GET,
            responseType: [User].self
        )
    }
    
    func getCurrentGroup() async throws -> UserGroup {
        return try await NetworkManager.shared.request(
            endpoint: groupsBaseURL,
            method: .GET,
            responseType: UserGroup.self
        )
    }
    
    func requestPasswordReset(body: ForgotPassword) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "forgot-password",
            method: .POST,
            body: body,
            responseType: VoidResponse.self
        )
    }
    
    func verifyRequestPasswordReset(body: ForgotPasswordVerify) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "forgot-password/verify",
            method: .POST,
            body: body,
            responseType: VoidResponse.self
        )
    }
    
    func resetPassword(body: ForgotPasswordReset) async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: baseURL + "forgot-password/reset",
            method: .POST,
            body: body,
            responseType: VoidResponse.self
        )
    }
    
    func updatePrimaryCaregiverOfCurrentUsersGroup(body: PrimaryCaregiverAssign) async throws -> UserGroup {
        return try await NetworkManager.shared.request(
            endpoint: groupsBaseURL + "primary-caregiver",
            method: .PUT,
            body: body,
            responseType: UserGroup.self
        )
    }
    
    func deletePrimaryCaregiverOfCurrentUsersGroup() async throws {
        _ = try await NetworkManager.shared.request(
            endpoint: groupsBaseURL + "primary-caregiver",
            method: .DELETE,
            responseType: VoidResponse.self
        )
    }
    
    func logout() async throws -> Void {
        // Mock endpoint doesnt work
//        _ = try await NetworkManager.shared.request(
//            endpoint: baseURL + "logout",
//            method: .POST,
//            responseType: VoidResponse.self
//        )
    }

}


