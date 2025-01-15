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
    
    
    public var isLoadingInitial: Bool = true
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "accessToken"
    private let authRefreshEndpoint = "auth/refresh"
    private let initialAccessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE3MzY0Njc4ODMsImlhdCI6MTczNjQ2NjY4MywianRpIjoiNmMyOTg2OWItZmNkMy00NjA0LWEyZjMtMWQ4NzA1N2M3Y2JiIiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3JlYWxtcy9wdHNzLXN1cHBvcnQiLCJzdWIiOiIxM2ZhZDAyYS03OTJlLTRmNWMtYTI3NC02ODNiZTgyZTY3NjYiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhdXRoZW50aWNhdGlvbi1zZXJ2aWNlIiwic2lkIjoiNzU4MzlhOTctNjNmZC00OTJmLTgxOGMtZTViZDU5ODg2YjIwIiwiYWNyIjoiMSIsImFsbG93ZWQtb3JpZ2lucyI6WyIqIl0sInNjb3BlIjoib3BlbmlkIHVzZXItZGV0YWlscyIsInVzZXJfaWQiOiIxM2ZhZDAyYS03OTJlLTRmNWMtYTI3NC02ODNiZTgyZTY3NjYiLCJncm91cF9pZCI6ImE1NWEzNWQzLTMwZjAtNDA4Yi1iMWQ0LWE2MDkxZWVjYzAzNiIsInJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwiZGVmYXVsdC1yb2xlcy1wdHNzLXN1cHBvcnQiLCJ1bWFfYXV0aG9yaXphdGlvbiJdLCJyb2xlIjoicGF0aWVudCIsImxhc3RfbmFtZSI6IkRlcnNqYW50IiwiZmlyc3RfbmFtZSI6IkZyYW5rIiwiaGFzX3BpbiI6ZmFsc2V9.xxoFGOVvy5AQKvkQOyvZ2s29SIRJOzrkPYjkZRtsWjk"
    
    private let apiService = UserService()

    init() {
        setInitialAccessToken()
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
        
        setLoggedIn()
    }
    
    public func register(_ body: UserRegister) async throws {
        _ = try await apiService.register(body: body)
    }
    
    private func getCurrentUser() async {
        do {
            let data = try await apiService.getCurrentUser()
            user = data
            isLoggedIn = true
            
            if let payload = getAccessTokenPayload() {
                hasPin = payload.hasPin
            } else {
                hasPin = false
            }
            //            hasPin = true
        } catch {
            print("Failed to check login status: \(error.localizedDescription)")
            isLoggedIn = false
            hasPin = false
        }
        isLoadingInitial = false
    }
    
    public func logout() async {
        do {
//            try await apiService.logout()
            
            clearCookies()
           
            print("User successfully logged out.")
        } catch {
            print("Failed to logout: \(error.localizedDescription)")
        }
    }
    
    
    private func setInitialAccessToken() {
        let cookieProperties: [HTTPCookiePropertyKey: Any] = [
            .name: accessTokenKey,
            .value: initialAccessToken,
            .domain: "localhost",
            .path: "/",
            .secure: false,
            .expires: Date().addingTimeInterval(3600) // 1 hour from now
        ]
        
        if let cookie = HTTPCookie(properties: cookieProperties) {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
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
    
    
    public func clearCookies() {
        isLoggedIn = false
        user = nil
        enteredPin = false
        hasPin = false
        
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                if cookie.name == accessTokenKey || cookie.name == refreshTokenKey {
                    cookieStorage.deleteCookie(cookie)
                }
            }
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
