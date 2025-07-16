//
//  KeychainHelper.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import Foundation
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    
    private init() {}
    
    private let service = "com.expert.oauth"
    
    enum KeychainError: Error {
        case noData
        case unexpectedData
        case unhandledError(status: OSStatus)
    }
    
    func save(_ data: Data, for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func read(for key: String) throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.noData
            }
            throw KeychainError.unhandledError(status: status)
        }
        
        guard let data = dataTypeRef as? Data else {
            throw KeychainError.unexpectedData
        }
        
        return data
    }
    
    func delete(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    func saveToken(_ token: String?, for key: String) {
        guard let token = token,
              let data = token.data(using: .utf8) else {
            try? delete(for: key)
            return
        }
        
        try? save(data, for: key)
    }
    
    func getToken(for key: String) -> String? {
        guard let data = try? read(for: key),
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return token
    }
}