//
//  WineViewModel.swift
//  WineFinder-iOS-Client
//
//  Created by Pawel Krezel on 31/03/2026.
//
import Foundation
import UIKit
import Combine

class WineViewModel: ObservableObject {
    
    @Published var wines: [Wine] = []
    
    private let service = WineService()
    
    func loadWines() {
        service.fetchWines { [weak self] fetched in
            self?.wines = fetched
        }
    }
    
    func addWine(wine: Wine, image: UIImage?, completion: @escaping () -> Void) {
        service.createWineWithImage(wine: wine, image: image) { success in
            if success {
                self.loadWines()
                completion()
            }
        }
    }
    
    func deleteWine(at indexSet: IndexSet) {
        for index in indexSet {
            let wine = wines[index]
            
            service.deleteWine(id: wine.id) { [weak self] success in
                if success {
                    self?.loadWines()
                }
            }
        }
    }

    func updateWine(wine: Wine, image: UIImage?, completion: @escaping () -> Void) {
        service.updateWineWithImage(wine: wine, image: image) { success in
            if success {
                self.loadWines()
                completion()
            }
        }
    }
}
