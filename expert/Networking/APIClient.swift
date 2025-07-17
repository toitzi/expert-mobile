//
//  APIClient.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import Foundation

@MainActor
class APIClient: NSObject, URLSessionTaskDelegate {
    static let shared = APIClient()
    
    private let authManager = AuthenticationManager.shared
    private let config = Configuration.shared
    private var retryCount = 0
    private let maxRetries = 1
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    private override init() {
        super.init()
    }
    
    /// Creates a URLRequest with the resource server base URL and authentication headers
    func createRequest(path: String, method: String = "GET") async -> URLRequest? {
        guard let accessToken = await authManager.getValidAccessToken() else {
            return nil
        }
        
        let url = config.api.resourceServerURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    /// Executes a request with automatic token refresh on 401
    func execute(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await session.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 && retryCount < maxRetries {
                    // Token might be expired, try to refresh
                    retryCount += 1
                    await authManager.refreshToken()
                    
                    // Check if still authenticated after refresh
                    if authManager.isAuthenticated {
                        // Retry the request with new token
                        if let newRequest = await recreateRequest(from: request) {
                            return try await execute(newRequest)
                        }
                    } else {
                        // Refresh failed, user needs to re-login
                        throw APIError.authenticationRequired
                    }
                }
                
                // Reset retry count on successful request
                retryCount = 0
            }
            
            return (data, response)
        } catch {
            retryCount = 0
            throw error
        }
    }
    
    /// Helper to recreate a request with updated token
    private func recreateRequest(from originalRequest: URLRequest) async -> URLRequest? {
        guard let accessToken = await authManager.getValidAccessToken(),
              let url = originalRequest.url else {
            return nil
        }
        
        var newRequest = URLRequest(url: url)
        newRequest.httpMethod = originalRequest.httpMethod
        newRequest.httpBody = originalRequest.httpBody
        
        // Copy headers except Authorization
        if let headers = originalRequest.allHTTPHeaderFields {
            for (key, value) in headers where key != "Authorization" {
                newRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Set new Authorization header
        newRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return newRequest
    }
}

enum APIError: LocalizedError {
    case authenticationRequired
    case invalidRequest
    
    var errorDescription: String? {
        switch self {
        case .authenticationRequired:
            return "Authentication required. Please log in again."
        case .invalidRequest:
            return "Invalid request configuration."
        }
    }
}

// Extension to make it easier to use with async/await
extension APIClient {
    /// Convenience method for GET requests
    func get(path: String) async throws -> (Data, URLResponse) {
        guard let request = await createRequest(path: path, method: "GET") else {
            throw APIError.invalidRequest
        }
        return try await execute(request)
    }
    
    /// Convenience method for GET requests with JSON decoding
    func get<T: Decodable>(_ path: String, type: T.Type) async throws -> T {
        let (data, _) = try await get(path: path)
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    /// Convenience method for POST requests
    func post(path: String, body: Data? = nil) async throws -> (Data, URLResponse) {
        guard var request = await createRequest(path: path, method: "POST") else {
            throw APIError.invalidRequest
        }
        
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return try await execute(request)
    }
    
    /// Convenience method for POST requests with JSON encoding/decoding
    func post<T: Encodable, R: Decodable>(_ path: String, body: T, responseType: R.Type) async throws -> R {
        let encoder = JSONEncoder()
        let bodyData = try encoder.encode(body)
        
        let (data, _) = try await post(path: path, body: bodyData)
        
        let decoder = JSONDecoder()
        return try decoder.decode(R.self, from: data)
    }
    
    /// Convenience method for PUT requests
    func put(path: String, body: Data? = nil) async throws -> (Data, URLResponse) {
        guard var request = await createRequest(path: path, method: "PUT") else {
            throw APIError.invalidRequest
        }
        
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return try await execute(request)
    }
    
    /// Convenience method for PUT requests with JSON encoding/decoding
    func put<T: Encodable, R: Decodable>(_ path: String, body: T, responseType: R.Type) async throws -> R {
        let encoder = JSONEncoder()
        let bodyData = try encoder.encode(body)
        
        let (data, _) = try await put(path: path, body: bodyData)
        
        let decoder = JSONDecoder()
        return try decoder.decode(R.self, from: data)
    }
    
    /// Convenience method for DELETE requests
    func delete(path: String) async throws -> (Data, URLResponse) {
        guard let request = await createRequest(path: path, method: "DELETE") else {
            throw APIError.invalidRequest
        }
        return try await execute(request)
    }
    
    /// Convenience method for DELETE requests with JSON response
    func delete<T: Decodable>(_ path: String, responseType: T.Type) async throws -> T {
        let (data, _) = try await delete(path: path)
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
