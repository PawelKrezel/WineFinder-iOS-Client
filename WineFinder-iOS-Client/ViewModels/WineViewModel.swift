//
//  WineViewModel.swift
//  WineFinder-iOS-Client
//
//  Created by Pawel Krezel on 31/03/2026.
//
import Foundation
import UIKit
import Combine

@MainActor
class WineViewModel: ObservableObject {
    
    @Published var wines: [Wine] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service = WineService()
    
    func loadWines() {
        Task{
            isLoading = true
            errorMessage = nil
            
            do {
                wines = try await service.fetchWines()
            } catch {
                errorMessage = "Failed to load wines \(error)"
                print("Load error: ", error)
            }
            isLoading = false
        }
    }
    
    func addWine(wine: Wine, image: UIImage?) {
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                try await service.createWine(wine: wine, image: image)
                await loadWines()
            } catch {
                errorMessage = "Failed to add wine \(error)"
                print("add wine error: ", error)
            }
            isLoading = false
        }
    }
    
    func updateWine(wine: Wine, image:UIImage?){
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                try await service.updateWine(wine: wine, image: image)
                await loadWines()
            } catch {
                errorMessage = "Failed to update wine \(error)"
                print("Update error:", error)
            }
            
            isLoading = false
        }
    }
    
    func deleteWine(id:String){
        Task{
            isLoading = true
            errorMessage = nil
            
            do{
                try await service.deleteWine(id: id)
                wines.removeAll{$0.id == id}
            } catch {
                errorMessage = "Failed to delete wine \(error)"
                print("Delete error:", error)
            }
            
            isLoading = false
        }
    }
}
