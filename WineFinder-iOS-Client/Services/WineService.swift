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
    func fetchWines(completion: @escaping ([Wine]) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            
            do {
                let wines = try JSONDecoder().decode([Wine].self, from: data)
                DispatchQueue.main.async {
                    completion(wines)
                }
            } catch {
                print("Decode error:", error)
            }
        }.resume()
    }
    
    // DELETE
    func deleteWine(id: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)\(id)/") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Token \(Config.shared.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let http = response as? HTTPURLResponse, http.statusCode == 204 {
                DispatchQueue.main.async { completion(true) }
            } else {
                completion(false)
            }
        }.resume()
    }
    
    // PUT
    func updateWine(wine: Wine, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)\(wine.id)/") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Token \(Config.shared.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(wine)
        } catch {
            print("Encode error:", error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                DispatchQueue.main.async { completion(true) }
            } else {
                completion(false)
            }
        }.resume()
    }
    
    func updateWineWithImage(
        wine: Wine,
        image: UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)\(wine.id)/") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Token \(Config.shared.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        func append(_ string: String) {
            body.append(string.data(using: .utf8)!)
        }
        
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
        
        for (key, value) in fields {
            append("--\(boundary)\r\n")
            append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            append("\(value)\r\n")
        }
        
        if let image = image,
           let data = image.jpegData(compressionQuality: 0.8) {
            
            append("--\(boundary)\r\n")
            append("Content-Disposition: form-data; name=\"image\"; filename=\"wine.jpg\"\r\n")
            append("Content-Type: image/jpeg\r\n\r\n")
            body.append(data)
            append("\r\n")
        }
        
        append("--\(boundary)--\r\n")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                DispatchQueue.main.async { completion(true) }
            } else {
                completion(false)
            }
        }.resume()
    }
    
    // POST (with image)
    func createWineWithImage(wine: Wine, image: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        var request = URLRequest(url: url)
        request.setValue("Token \(Config.shared.token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        func append(_ string: String) {
            body.append(string.data(using: .utf8)!)
        }
        
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
        
        for (key, value) in fields {
            append("--\(boundary)\r\n")
            append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            append("\(value)\r\n")
        }
        
        if let image = image,
           // TODO: CONSIDER IF IT'S NEEDED
           let data = image.jpegData(compressionQuality: 0.8) {
            
            append("--\(boundary)\r\n")
            append("Content-Disposition: form-data; name=\"image\"; filename=\"wine.jpg\"\r\n")
            append("Content-Type: image/jpeg\r\n\r\n")
            body.append(data)
            append("\r\n")
        }
        
        append("--\(boundary)--\r\n")
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { _, response, _ in
            if let http = response as? HTTPURLResponse, http.statusCode == 201 {
                DispatchQueue.main.async { completion(true) }
            } else {
                completion(false)
            }
        }.resume()
    }
}
