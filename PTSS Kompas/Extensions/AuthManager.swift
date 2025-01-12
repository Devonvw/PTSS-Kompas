//
//  AuthManager.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 16/12/2024.
//


import Foundation

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isLoggedIn: Bool = false //false
    @Published var user: User?
    @Published var enteredPin: Bool = false // false
    @Published var hasPin: Bool = false // false
    
    
    public var isLoadingInitial: Bool = false
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "accessToken"
    private let authRefreshEndpoint = "auth/refresh"
    
    private let apiService = UserService()
    
    init() {
        Task {
            isLoadingInitial = true
            await getCurrentUser()
        }
    }
    
    public func setLoggedIn() {
        isLoggedIn = true
        enteredPin = true
        
        Task {
            await getCurrentUser()
        }
    }
    
    public func pinLogin(_ body: PinLogin) async throws {
        _ = try await apiService.loginPin(body: body)
        setLoggedIn()
    }
    
    public func login(_ body: Login) async throws {
        _ = try await apiService.login(body: body)
        
        print("klaar")
        setLoggedIn()
    }
    
    public func register(_ body: UserRegister) async throws {
        _ = try await apiService.register(body: body)
    }
    
    private func getCurrentUser() async {
        do {
            let data = try await apiService.getCurrentUser()
            print(data)
            user = data
            isLoggedIn = true
            
            // Decode access token payload
            if let payload = getAccessTokenPayload() {
                hasPin = payload.hasPin
            } else {
                hasPin = false
            }
        } catch {
            print("Failed to check login status: \(error.localizedDescription)")
            isLoggedIn = false
            hasPin = false
        }
        isLoadingInitial = false
    }
    
    public func getAccessTokenPayload() -> AccessTokenPayload? {
        guard let token = getAccessTokenCookie() else {
            return nil
        }
        return decodeJWTPayload(token: token)
    }
    
    private func getAccessTokenCookie() -> String? {
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies where cookie.name == accessTokenKey {
                return cookie.value
            }
        }
        return nil
    }
    
    private func decodeJWTPayload(token: String) -> AccessTokenPayload? {
        let components = token.split(separator: ".")
        guard components.count > 1 else {
            return nil
        }
        
        let payloadBase64 = String(components[1])
        guard let payloadData = Data(base64Encoded: payloadBase64) else {
            return nil
        }
        
        do {
            let payload = try JSONDecoder().decode(AccessTokenPayload.self, from: payloadData)
            return payload
        } catch {
            print("Failed to decode JWT payload: \(error.localizedDescription)")
            return nil
        }
    }
    
    //    private func checkLoginStatus() async {
    //        isLoadingInitial = true
    //        do {
    //            guard let _refreshToken = KeychainManager.shared.retrieveToken(for: refreshTokenKey) else {
    //                isLoggedIn = false
    //                isLoadingInitial = false
    //
    //                return
    //            }
    //
    //            if try isTokenExpired(_refreshToken) == true {
    //                isLoggedIn = false
    //                isLoadingInitial = false
    //                return
    //            }
    //
    //            isLoggedIn = true
    //            isLoadingInitial = false
    //        } catch {
    //            print("Failed to check login status: \(error.localizedDescription)")
    //            isLoggedIn = false
    //            isLoadingInitial = false
    //        }
    //    }
    //
    //    public func isTokenExpired(_ token: String) throws -> Bool? {
    //        print("kaas3", token)
    //        let payload = try decode(jwtToken: token)
    //        guard let exp = payload["exp"] as? TimeInterval else {
    //            return nil
    //        }
    //        print("kaas4")
    //
    //        let currentTime = Date().timeIntervalSince1970
    //        return currentTime > exp
    //    }
    //
    //    private func decode(jwtToken jwt: String) throws -> [String: Any] {
    //        enum DecodeErrors: Error {
    //            case badToken
    //            case other
    //        }
    //
    //        func base64Decode(_ base64: String) throws -> Data {
    //            let base64 = base64
    //                .replacingOccurrences(of: "-", with: "+")
    //                .replacingOccurrences(of: "_", with: "/")
    //            let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
    //            guard let decoded = Data(base64Encoded: padded) else {
    //                throw DecodeErrors.badToken
    //            }
    //            return decoded
    //        }
    //
    //        func decodeJWTPart(_ value: String) throws -> [String: Any] {
    //            let bodyData = try base64Decode(value)
    //            let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
    //            guard let payload = json as? [String: Any] else {
    //                throw DecodeErrors.other
    //            }
    //            return payload
    //        }
    //
    //        let segments = jwt.components(separatedBy: ".")
    //        guard segments.count > 1 else { throw DecodeErrors.badToken }
    //        return try decodeJWTPart(segments[1])
    //    }
    //
    //    public func refreshToken() async throws {
    //        guard let refreshToken = KeychainManager.shared.retrieveToken(for: refreshTokenKey) else {
    //            throw NetworkError.unknown(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing refresh token"]))
    //        }
    //
    //        let body: [String: String] = ["refreshToken": refreshToken]
    //        let response: AuthResponse = try await NetworkManager.shared.request(
    //            endpoint: authRefreshEndpoint,
    //            method: .POST,
    //            body: body,
    //            responseType: AuthResponse.self
    //        )
    //
    //        _ = KeychainManager.shared.saveToken(response.accessToken, for: accessTokenKey)
    //    }
    //
    //    public func getToken(for account: String) -> String? {
    //        return KeychainManager.shared.retrieveToken(for: account)
    //    }
}
