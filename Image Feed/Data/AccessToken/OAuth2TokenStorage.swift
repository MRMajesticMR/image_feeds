//
//  AccessTokenRepository.swift
//  Image Feed
//
//  Created by Аркадий Захаров on 27.12.2023.
//

import Foundation

class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    private static let KEY_ACCESS_TOKEN = "KEY_ACCESS_TOKEN"
    
    
    private let userDefaults = UserDefaults.standard
    
    func saveToken(_ token: String?) {
        userDefaults.set(token, forKey: OAuth2TokenStorage.KEY_ACCESS_TOKEN)
    }
    
    func getToken() -> String? {
        userDefaults.string(forKey: OAuth2TokenStorage.KEY_ACCESS_TOKEN)
    }
}
