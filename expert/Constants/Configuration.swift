//
//  Configuration.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import Foundation

struct Configuration {
    static let shared = Configuration()
    
    struct OAuth {
        let issuer: URL
        let clientID: String
        let redirectURI: String
        let scopes: [String]
        
        var scopesString: String {
            scopes.joined(separator: " ")
        }
    }
    
    struct API {
        let resourceServerURL: URL
    }
    
    let oauth: OAuth
    let api: API
    
    private init() {
        guard let infoPlist = Bundle.main.infoDictionary,
              let oauthConfig = infoPlist["OAuthConfiguration"] as? [String: Any],
              let apiConfig = infoPlist["APIConfiguration"] as? [String: Any] else {
            fatalError("Configuration not found in Info.plist. Please ensure Config.xcconfig is properly set up.")
        }
        
        // OAuth Configuration
        guard let issuerString = oauthConfig["Issuer"] as? String,
              let issuerURL = URL(string: issuerString),
              let clientID = oauthConfig["ClientID"] as? String,
              let redirectScheme = oauthConfig["RedirectScheme"] as? String,
              let redirectPath = oauthConfig["RedirectPath"] as? String,
              let scopesString = oauthConfig["Scopes"] as? String else {
            fatalError("Invalid OAuth configuration in Info.plist")
        }
        
        let redirectURI = "\(redirectScheme)://\(redirectPath)"
        let scopes = scopesString.split(separator: " ").map(String.init)
        
        self.oauth = OAuth(
            issuer: issuerURL,
            clientID: clientID,
            redirectURI: redirectURI,
            scopes: scopes
        )
        
        // API Configuration
        guard let resourceServerURLString = apiConfig["ResourceServerURL"] as? String,
              let resourceServerURL = URL(string: resourceServerURLString) else {
            fatalError("Invalid API configuration in Info.plist")
        }
        
        self.api = API(
            resourceServerURL: resourceServerURL
        )
    }
}
