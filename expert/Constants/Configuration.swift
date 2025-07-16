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
    
    let oauth = OAuth(
        issuer: URL(string: "http://localhost:3000")!,
        clientID: "9f640cbf-9637-44cd-86d1-2363cdfab1ca",
        redirectURI: "com.expert.oauth://callback",
        scopes: ["openid", "profile", "email"]
    )
    
    let api = API(
        resourceServerURL: URL(string: "http://localhost:3000")!
    )
    
    private init() {}
}
