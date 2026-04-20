//
//  APIClient.swift
//  WineFinder-iOS-Client
//
//  Created by Pawel Krezel on 02/04/2026.
//

import Foundation

class APIClient {
    
    static let shared = APIClient()
    private let baseURL = Config.shared.baseURL
    private init() {}
    
    // Generic request builder
    func makeRequest(
        path: String,
        method: String,
        body: Data? = nil,
        contentType: String = "application/json"
    ) async throws -> Data {
        guard let url = URL(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        request.setValue("Token \(Config.shared.token)", forHTTPHeaderField: "Authorization")
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let(data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard(200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
