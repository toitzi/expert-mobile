//
//  AuthenticationManager.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import Foundation
import AuthenticationServices
import SwiftUI
import CommonCrypto

@MainActor
class AuthenticationManager: NSObject, ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var isRefreshing = false
    @Published var currentUser: UserInfo?
    
    private let keychainHelper = KeychainHelper.shared
    private let config = Configuration.shared.oauth
    
    private var authSession: ASWebAuthenticationSession?
    private var refreshTask: Task<Void, Error>?
    
    private override init() {
        super.init()
        checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        let accessToken = keychainHelper.getToken(for: "access_token")
        isAuthenticated = accessToken != nil
        
        if isAuthenticated {
            Task {
                // Check if token is expired and refresh if needed
                if isTokenExpired() {
                    await refreshToken()
                }
                
                // Re-check authentication after potential refresh
                let validToken = keychainHelper.getToken(for: "access_token")
                isAuthenticated = validToken != nil
                
                if isAuthenticated {
                    await fetchUserInfo()
                }
            }
        }
    }
    
    func getAccessToken() -> String? {
        return keychainHelper.getToken(for: "access_token")
    }
    
    func isTokenExpired() -> Bool {
        guard let expiryDate = UserDefaults.standard.object(forKey: "token_expiry") as? Date else {
            return true
        }
        return Date() >= expiryDate.addingTimeInterval(-60) // Refresh 1 minute before expiry
    }
    
    func getValidAccessToken() async -> String? {
        if isTokenExpired() {
            await refreshToken()
        }
        return getAccessToken()
    }
    
    func refreshToken() async {
        // If a refresh is already in progress, wait for it
        if let existingTask = refreshTask {
            do {
                try await existingTask.value
                return
            } catch {
                // If the existing task failed, we'll try again
            }
        }
        
        isRefreshing = true
        
        // Create a new refresh task
        refreshTask = Task {
            guard let refreshToken = keychainHelper.getToken(for: "refresh_token") else {
                logout()
                throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No refresh token"])
            }
            
            let tokenEndpoint = config.issuer.appendingPathComponent("oauth/token")
            var request = URLRequest(url: tokenEndpoint)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let parameters = [
                "grant_type": "refresh_token",
                "refresh_token": refreshToken,
                "client_id": config.clientID
            ]
            
            let body = parameters
                .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
                .joined(separator: "&")
            
            request.httpBody = body.data(using: .utf8)
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                
                keychainHelper.saveToken(tokenResponse.accessToken, for: "access_token")
                if let newRefreshToken = tokenResponse.refreshToken {
                    keychainHelper.saveToken(newRefreshToken, for: "refresh_token")
                }
                
                if let expiresIn = tokenResponse.expiresIn {
                    let expiryDate = Date().addingTimeInterval(TimeInterval(expiresIn))
                    UserDefaults.standard.set(expiryDate, forKey: "token_expiry")
                }
                
                print("Token refreshed successfully")
                
                // Fetch user info again to update UI
                await fetchUserInfo()
            } catch {
                print("Token refresh error: \(error)")
                logout()
                throw error
            }
        }
        
        // Wait for the task to complete
        do {
            try await refreshTask?.value
        } catch {
            // Error already handled above
        }
        
        // Clear the task when done
        refreshTask = nil
        isRefreshing = false
    }
    
    func fetchUserInfo() async {
        do {
            let (data, _) = try await APIClient.shared.get(path: "api/user")
            let userInfo = try JSONDecoder().decode(UserInfo.self, from: data)
            currentUser = userInfo
        } catch APIError.authenticationRequired {
            print("Authentication required - logging out")
            logout()
        } catch {
            print("Failed to fetch user info: \(error)")
        }
    }
    
    func login() {
        isLoading = true
        
        let authorizationEndpoint = config.issuer.appendingPathComponent("oauth/authorize")
        let tokenEndpoint = config.issuer.appendingPathComponent("oauth/token")
        
        let state = UUID().uuidString
        let codeVerifier = generateCodeVerifier()
        let codeChallenge = generateCodeChallenge(from: codeVerifier)
        
        var components = URLComponents(url: authorizationEndpoint, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: config.clientID),
            URLQueryItem(name: "redirect_uri", value: config.redirectURI),
            URLQueryItem(name: "scope", value: config.scopesString),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "S256")
        ]
        
        guard let authURL = components.url else {
            isLoading = false
            return
        }
        
        print("Starting OAuth flow with URL: \(authURL)")
        print("Redirect URI: \(config.redirectURI)")
        print("Scopes: \(config.scopesString)")
        
        // Store code verifier for later use
        UserDefaults.standard.set(codeVerifier, forKey: "codeVerifier")
        UserDefaults.standard.set(state, forKey: "authState")
        
        authSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: "com.expert.oauth") { [weak self] callbackURL, error in
            guard let self = self else { return }
            
            if let error = error {
                if case ASWebAuthenticationSessionError.canceledLogin = error {
                    print("User canceled login")
                } else {
                    print("Authentication error: \(error)")
                }
                self.isLoading = false
                return
            }
            
            guard let callbackURL = callbackURL,
                  let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
                  let code = components.queryItems?.first(where: { $0.name == "code" })?.value,
                  let returnedState = components.queryItems?.first(where: { $0.name == "state" })?.value,
                  returnedState == state else {
                print("Invalid callback URL or state mismatch")
                self.isLoading = false
                return
            }
            
            Task {
                await self.exchangeCodeForTokens(code: code, codeVerifier: codeVerifier, tokenEndpoint: tokenEndpoint)
            }
        }
        
        authSession?.presentationContextProvider = self
        authSession?.prefersEphemeralWebBrowserSession = false
        authSession?.start()
    }
    
    private func exchangeCodeForTokens(code: String, codeVerifier: String, tokenEndpoint: URL) async {
        var request = URLRequest(url: tokenEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let parameters = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": config.redirectURI,
            "client_id": config.clientID,
            "code_verifier": codeVerifier
        ]
        
        let body = parameters
            .map { "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
        
        request.httpBody = body.data(using: .utf8)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            
            keychainHelper.saveToken(tokenResponse.accessToken, for: "access_token")
            keychainHelper.saveToken(tokenResponse.refreshToken, for: "refresh_token")
            
            // Save token expiry time
            if let expiresIn = tokenResponse.expiresIn {
                let expiryDate = Date().addingTimeInterval(TimeInterval(expiresIn))
                UserDefaults.standard.set(expiryDate, forKey: "token_expiry")
            }
            
            isAuthenticated = true
            isLoading = false
            
            // Fetch user info
            await fetchUserInfo()
        } catch {
            print("Token exchange error: \(error)")
            isLoading = false
        }
    }
    
    func logout() {
        keychainHelper.saveToken(nil, for: "access_token")
        keychainHelper.saveToken(nil, for: "refresh_token")
        UserDefaults.standard.removeObject(forKey: "token_expiry")
        currentUser = nil
        isAuthenticated = false
    }
    
    private func generateCodeVerifier() -> String {
        var buffer = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
        return Data(buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    private func generateCodeChallenge(from verifier: String) -> String {
        let data = verifier.data(using: .utf8)!
        var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &buffer)
        }
        return Data(buffer).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}

extension AuthenticationManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window found")
        }
        return window
    }
}

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let tokenType: String
    let expiresIn: Int?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}
