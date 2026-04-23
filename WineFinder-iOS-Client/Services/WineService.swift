//
//  WineService.swift
//  WineFinder-iOS-Client
//
//  Created by Pawel Krezel on 31/03/2026.
//
import Foundation
import UIKit

class WineService {
    
    private let baseURL = Config.shared.baseURL
    
    // GET
    func fetchWines() async throws -> [Wine]{
        let data = try await APIClient.shared.makeRequest(
            path: "/api/wines/",
            method: "GET")
        return try JSONDecoder().decode([Wine].self, from: data)
    }
    
    // DELETE
    func deleteWine(id: String) async throws {
        _ = try await APIClient.shared.makeRequest(
            path: "/api/wines/\(id)/",
            method: "DELETE")
    }
    
    // PUT
    func updateWine(wine: Wine, image: UIImage?) async throws {
        
        let body: Data
        let contentType: String
        
        if let image = image {
            // upload with image
            let result = buildMultipartBody(wine: wine, image: image)
            body = result.0
            contentType = result.1
        } else {
            
            // pure JSON with no image
            body = try JSONEncoder().encode(wine)
            contentType = "application/json"
        }
        
        _ = try await APIClient.shared.makeRequest(
            path: "/api/wines/\(wine.id)/",
            method: "PUT",
            body: body,
            contentType: contentType)
    }
    
    // POST
    func createWine(wine: Wine, image: UIImage?) async throws {
        let body: Data
        let contentType:String
        
        if let image = image {
            // upload with image
            let result = buildMultipartBody(wine: wine, image: image)
            body = result.0
            contentType = result.1
        } else {
            
            // pure JSON with no image
            body = try JSONEncoder().encode(wine)
            contentType = "application/json"
        }
        
        _ = try await APIClient.shared.makeRequest(
            path: "/api/wines/",
            method: "POST",
            body:body,
            contentType: contentType)
    }
    
    // helper function for image uploads
    private func buildMultipartBody(wine: Wine, image: UIImage?) -> (Data, String) {
        
        let boundary = UUID().uuidString
        var body = Data()
        
        func append(_ string: String) {
            body.append(string.data(using: .utf8)!)
        }
        
        // converts wine model into key-value pairs
        let fields: [String: String] = [
            "wine_name": wine.wine_name,
            "grape": wine.grape,
            "region": wine.region,
            "country_of_origin": wine.country_of_origin,
            "vintage": "\(wine.vintage)",
            "body": wine.body,
            "tannin": wine.tannin,
            "acidity": wine.acidity,
            "glass": wine.glass,
            "coravin": wine.coravin,
            "btl_only": wine.btl_only,
            "sommNotes": wine.sommNotes ?? "",
            "colour": wine.colour
        ]
        
        // appends each key as a seperate part
        for (key, value) in fields {
            append("--\(boundary)\r\n")
            append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            append("\(value)\r\n")
        }
        
        // append img if present
        if let image = image,
           let data = image.jpegData(compressionQuality: 0.8) {
            
            append("--\(boundary)\r\n")
            append("Content-Disposition: form-data; name=\"image\"; filename=\"wine.jpg\"\r\n")
            append("Content-Type: image/jpeg\r\n\r\n")
            body.append(data)
            append("\r\n")
        }
        
        append("--\(boundary)--\r\n")
        
        let contentType = "multipart/form-data; boundary=\(boundary)"
        
        return (body, contentType)
    }
}
