//
//  AccessTokenPayoad.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 12/01/2025.
//

import Foundation

struct AccessTokenPayload: Codable {
    let exp: Int
    let iat: Int
    let jti: String
    let iss: String
    let sub: String
    let typ: String
    let azp: String
    let sid: String
    let acr: String
    let allowedOrigins: [String]
    let scope: String
    let userID: String
    let groupID: String
    let roles: [String]
    let role: Role
    let lastName: String
    let firstName: String
    let hasPin: Bool

    enum CodingKeys: String, CodingKey {
        case exp, iat, jti, iss, sub, typ, azp, sid, acr, scope, role
        case allowedOrigins = "allowed-origins"
        case userID = "user_id"
        case groupID = "group_id"
        case roles
        case lastName = "last_name"
        case firstName = "first_name"
        case hasPin = "has_pin"
    }
}

