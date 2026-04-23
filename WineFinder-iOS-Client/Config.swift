//
//  Config.swift
//  WineFinder-iOS-Client
//
//  Created by Pawel Krezel on 02/04/2026.
//

import Foundation

struct Config {
    // reads data from config.plist. Originally this file was not included in public github for security rasons.
    // included for submission 
    static let shared = Config()
    
    let baseURL: String
    let token: String
    
    private init() {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            fatalError("Config.plist not found")
        }
        
        self.baseURL = dict["API_BASE_URL"] as? String ?? ""
        self.token = dict["API_TOKEN"] as? String ?? ""
    }
}
