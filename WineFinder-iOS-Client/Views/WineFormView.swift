//
//  WineFormView.swift
//  WineFinder-iOS-Client
//
//  Created by Pawel Krezel on 02/04/2026.
//

import SwiftUI
import UIKit

struct WineFormView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let viewModel: WineViewModel
    var wine: Wine?
    
    var isEditing: Bool { wine != nil }
    
    // MARK: - State
    
    @State private var name = ""
    @State private var grape = ""
    @State private var region = ""
    @State private var country = ""
    @State private var vintage = ""
    
    @State private var wineBody = "medium-body"
    @State private var tannin = "no-tannin"
    @State private var acidity = "medium-acidity"
    @State private var colour = "Red"
    
    @State private var glass = "Standard"
    @State private var coravin = "No"
    @State private var btlOnly = "No"
    
    @State private var notes = ""
    
    // Image
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showSourcePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    var body: some View {
        NavigationStack {
            
            Form {
                
                // MARK: - Basic
                Section("Basic Info") {
                    TextField("Name", text: $name)
                    TextField("Grape", text: $grape)
                    TextField("Vintage", text: $vintage)
                        .keyboardType(.numberPad)
                }
                
                // MARK: - Origin
                Section("Origin") {
                    TextField("Region", text: $region)
                    TextField("Country", text: $country)
                }
                
                // MARK: - Characteristics
                Section("Characteristics") {
                    
                    Picker("Body", selection: $wineBody) {
                        Text("Light").tag("light-body")
                        Text("Medium").tag("medium-body")
                        Text("Full").tag("full-body")
                    }
                    
                    Picker("Tannin", selection: $tannin) {
                        Text("None").tag("no-tannin")
                        Text("Light").tag("light-tannin")
                        Text("Medium").tag("medium-tannin")
                        Text("Full").tag("full-tannin")
                    }
                    
                    Picker("Acidity", selection: $acidity) {
                        Text("Low").tag("low-acidity")
                        Text("Medium").tag("medium-acidity")
                        Text("High").tag("high-acidity")
                    }
                    
                    Picker("Colour", selection: $colour) {
                        Text("Red").tag("Red")
                        Text("White").tag("White")
                        Text("Rosé").tag("Rose")
                        Text("Orange").tag("Orange")
                    }
                }
                
                // MARK: - Service
                Section("Service") {
                    
                    Picker("Glass", selection: $glass) {
                        Text("Standard").tag("Standard")
                        Text("Burgundy").tag("Burgundy")
                        Text("Bordeaux").tag("Bordeaux")
                        Text("Flute").tag("Flute")
                        Text("Tasting").tag("Tst")
                    }
                    
                    Picker("Coravin", selection: $coravin) {
                        Text("Yes").tag("Yes")
                        Text("No").tag("No")
                    }
                    
                    Picker("Bottle Only", selection: $btlOnly) {
                        Text("Yes").tag("Yes")
                        Text("No").tag("No")
                    }
                }
                
                // MARK: - Notes
                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 120)
                }
                
                // MARK: - Image
                Section("Image") {
                    
                    Button("Select Image") {
                        showSourcePicker = true
                    }
                    
                    .confirmationDialog("Image Source", isPresented: $showSourcePicker) {
                        Button("Camera") {
                            sourceType = .camera
                            showingImagePicker = true
                        }
                        Button("Photo Library") {
                            sourceType = .photoLibrary
                            showingImagePicker = true
                        }
                    }
                    
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
            }
            
            .navigationTitle(isEditing ? "Edit Wine" : "Add Wine")
            
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                }
            }
            
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: sourceType)
            }
            
            .onAppear {
                setupInitialValues()
            }
        }
    }
    
    
    // MARK: - Setup
    
    func setupInitialValues() {
        guard let wine = wine else { return }
        
        name = wine.wine_name
        grape = wine.grape
        region = wine.region
        country = wine.country_of_origin
        vintage = "\(wine.vintage)"
        
        wineBody = wine.body
        tannin = wine.tannin
        acidity = wine.acidity
        colour = wine.colour
        
        glass = wine.glass
        coravin = wine.coravin
        btlOnly = wine.btl_only
        
        notes = wine.sommNotes ?? ""
    }
    
    
    // MARK: - Save
    
    func save() {
        
        let wineToSave = Wine(
            id: wine?.id ?? UUID().uuidString,
            wine_name: name,
            grape: grape,
            region: region,
            country_of_origin: country,
            vintage: Int(vintage) ?? 2020,
            body: wineBody,
            tannin: tannin,
            acidity: acidity,
            glass: glass,
            coravin: coravin,
            btl_only: btlOnly,
            sommNotes: notes,
            imageURL: wine?.imageURL,
            colour: colour,
            slots:wine?.slots ?? nil
        )
        
        if isEditing {
            viewModel.updateWine(wine: wineToSave, image: selectedImage)
        } else {
            viewModel.addWine(wine: wineToSave, image: selectedImage)
        }
        
        dismiss()
    }
}
