//
//  WineViewModel.swift
//  WineFinder-iOS-Client
//
//  Created by Pawel Krezel on 31/03/2026.
//
import Foundation
import UIKit
import Combine

@MainActor // All ui related updates on main thread
class WineViewModel: ObservableObject {
    @Published var selectedWine: Wine?
    @Published var wines: [Wine] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service = WineService()
    
    // uses service to load wines
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
    
    // uses service to add wines
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
    
    // uses service to update wines
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
    
    // uses service to delete wines
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
