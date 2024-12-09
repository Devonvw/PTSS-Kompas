//
//  UserService.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

import Foundation

final class UserService {
    let baseURL = "users/"
   
    func inviteUser(body: UserInviteCreate, completion: @escaping (Result<Never, NetworkError>) -> Void) {
        NetworkManager.shared.request(
            endpoint: baseURL + "invite",
            method: .POST,
            body: body,
            responseType: Never.self,
            completion: completion
        )
    }
}
