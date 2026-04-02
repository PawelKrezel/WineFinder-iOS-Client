//
//  Wine.swift
//  WineFinder-iOS-Client
//
//  Created by Pawel Krezel on 31/03/2026.
//
import Foundation

struct Wine: Identifiable, Codable {
    let id: String
    let wine_name: String
    let grape: String
    let region: String
    let country_of_origin: String
    let vintage: Int
    let body: String
    let tannin: String
    let acidity: String
    let glass: String
    let coravin: String
    let btl_only: String
    let sommNotes: String?
    let imageURL: String?
    let colour: String
}
