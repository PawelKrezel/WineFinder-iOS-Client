//
//  WineFormView.swift
//  WineFinder-iOS-Client
//
//  Created by Pawel Krezel on 31/03/2026.
//

import SwiftUI

struct WineFormView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let viewModel: WineViewModel
    var wine: Wine?   // 🔥 nil = add, not nil = edit
    
    @State private var name: String = ""
    @State private var grape: String = ""
    
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    @State private var showSourcePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var isEditing: Bool {
        wine != nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Grape", text: $grape)
                
                Button("Select Image") {
                    showSourcePicker = true
                }
                .confirmationDialog("Select Image Source", isPresented: $showSourcePicker) {
                    
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
                        .frame(height: 150)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(
                    image: $selectedImage,
                    sourceType: sourceType
                )
            }
            .navigationTitle(isEditing ? "Edit Wine" : "Add Wine")
            .toolbar {
                Button("Save") {
                    save()
                }
            }
            .onAppear {
                setupInitialValues()
            }
        }
    }
    
    // 🔥 Pre-fill when editing
    func setupInitialValues() {
        guard let wine = wine else { return }
        
        name = wine.wine_name
        grape = wine.grape
    }
    
    // 🔥 Single save function
    func save() {
        // 🔥 Build wine from form fields
        let wineToSave = Wine(
            id: wine?.id ?? UUID().uuidString,
            wine_name: name,
            grape: grape,
            region: wine?.region ?? "Test",
            country_of_origin: wine?.country_of_origin ?? "Test",
            vintage: wine?.vintage ?? 2020,
            body: wine?.body ?? "medium-body",
            tannin: wine?.tannin ?? "no-tannin",
            acidity: wine?.acidity ?? "medium-acidity",
            glass: wine?.glass ?? "Standard",
            coravin: wine?.coravin ?? "No",
            btl_only: wine?.btl_only ?? "No",
            sommNotes: wine?.sommNotes ?? "",
            imageURL: wine?.imageURL,
            colour: wine?.colour ?? "Red"
        )

        if isEditing {
            viewModel.updateWine(wine: wineToSave, image: selectedImage) {
                dismiss()
            }
        } else {
            viewModel.addWine(wine: wineToSave, image: selectedImage) {
                dismiss()
            }
        }
    }
}
