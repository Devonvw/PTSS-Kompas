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
    
    func inviteUser(body: UserInviteCreate, completion: @escaping (Result<Never, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "invite",
            method: .POST,
            body: body,
            responseType: Never.self,
            completion: completion
        )
    }
    
    func verifyUserInvitation(body: UserInviteVerify, completion: @escaping (Result<Never, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "invite/verify",
            method: .POST,
            body: body,
            responseType: Never.self,
            completion: completion
        )
    }
    
    func register(body: UserRegister, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "register",
            method: .POST,
            body: body,
            responseType: AuthResponse.self,
            completion: completion
        )
    }
    
    func login(body: Login, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "login",
            method: .POST,
            body: body,
            responseType: AuthResponse.self,
            completion: completion
        )
    }
    
    func loginPin(body: PinLogin, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "login",
            method: .POST,
            body: body,
            responseType: AuthResponse.self,
            completion: completion
        )
    }
    
    func getCurrentUser(completion: @escaping (Result<User, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "me",
            method: .GET,
            responseType: User.self,
            completion: completion
        )
    }
    
    func deleteUserFromGroup(userId: String, completion: @escaping (Result<Never, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "\(userId)",
            method: .DELETE,
            responseType: Never.self,
            completion: completion
        )
    }
    
    func updatePassword(body: PasswordUpdate, completion: @escaping (Result<AuthResponse, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "me/password",
            method: .PUT,
            body: body,
            responseType: AuthResponse.self,
            completion: completion
        )
    }
    
    func createPin(body: PinCreate, completion: @escaping (Result<Never, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "me/pin",
            method: .POST,
            body: body,
            responseType: Never.self,
            completion: completion
        )
    }
    
    func updatePin(body: PinUpdate, completion: @escaping (Result<Never, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "me/pin",
            method: .PUT,
            body: body,
            responseType: Never.self,
            completion: completion
        )
    }
    
    func getMembersOfCurrentUsersGroup(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: groupsBaseURL + "members",
            method: .GET,
            responseType: [User].self,
            completion: completion
        )
    }
    
    func getCurrentGroup(completion: @escaping (Result<UserGroup, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: groupsBaseURL,
            method: .GET,
            responseType: UserGroup.self,
            completion: completion
        )
    }
    
    func requestPasswordReset(body: ForgotPassword, completion: @escaping (Result<Never, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "forgot-password",
            method: .POST,
            body: body,
            responseType: Never.self,
            completion: completion
        )
    }
    
    func verifyRequestPasswordReset(body: ForgotPasswordVerify, completion: @escaping (Result<Never, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "forgot-password/verify",
            method: .POST,
            body: body,
            responseType: Never.self,
            completion: completion
        )
    }
    
    func resetPassword(body: ForgotPasswordReset, completion: @escaping (Result<Never, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "forgot-password/reset",
            method: .POST,
            body: body,
            responseType: Never.self,
            completion: completion
        )
    }
    
    //    func getPrimaryCaregiverOfCurrentUsersGroup(completion: @escaping (Result<[User], NetworkError>) -> Void) {
    //        NetworkManager.shared.request(
    //            endpoint: groupsBaseURL + "members",
    //            method: .GET,
    //            responseType: [User].self,
    //            completion: completion
    //        )
    //    }
    
    func updatePrimaryCaregiverOfCurrentUsersGroup(body: PrimaryCaregiverAssign, completion: @escaping (Result<UserGroup, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: groupsBaseURL + "primary-caregiver",
            method: .PUT,
            body: body,
            responseType: UserGroup.self,
            completion: completion
        )
    }
    
    func deletePrimaryCaregiverOfCurrentUsersGroup(completion: @escaping (Result<Never, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: groupsBaseURL + "primary-caregiver",
            method: .DELETE,
            responseType: Never.self,
            completion: completion
        )
    }
}
