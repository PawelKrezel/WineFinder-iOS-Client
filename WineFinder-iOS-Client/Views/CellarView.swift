// CellarView.swift
import SwiftUI

struct CellarView: View {
    let wines: [Wine]
    let selectedWine: Wine?
    let onWineSelected: (Wine) -> Void
    @Binding var editableSlots: Set<String>
    
    @State private var selectedSlotForPopup: String?
    @State private var selectedWineForPopup: Wine?
    
    var occupiedSlots: Set<String> {
        var set = Set<String>()
        
        for wine in wines {
            if let slots = wine.slots {
                for slot in slots {
                    set.insert(slot)
                }
            }
        }
        
        return set
    }
    
    var selectedSlots: Set<String> {
        guard let slots = selectedWine?.slots else { return [] }
        return Set(slots)
    }
    
    var slotToWine: [String: Wine] {
        var map: [String: Wine] = [:]
        
        for wine in wines {
            for slot in wine.slots ?? [] {
                map[slot] = wine
            }
        }
        
        return map
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .top, spacing: 10) {
                
                ForEach(1...6, id: \.self) { shelf in
                    
                    VStack(spacing: 5) {
                        
                        Text("Shelf \(shelf)")
                            .font(.headline)
                        
                        LazyVGrid(columns: columns(for: shelf), spacing: 2) {
                            
                            ForEach(generateSlots(for: shelf), id: \.self) { slot in
                                Rectangle()
                                    .fill(
                                        editableSlots.contains(slot) ? Color.blue :
                                        (occupiedSlots.contains(slot) && !selectedSlots.contains(slot)) ? Color.red :
                                        Color.gray.opacity(0.3)
                                    )
                                    .frame(width: 20, height: 20)
                                    .onTapGesture {
                                        toggleSlot(slot)
                                    }
                                    .onLongPressGesture {
                                        if let wine = slotToWine[slot],
                                           !editableSlots.contains(slot) {
                                            selectedSlotForPopup = slot
                                            selectedWineForPopup = wine // Triggers the sheet presentation
                                        }
                                    }
                            }
                        }
                    }
                    // Wall seperating the shelves
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 10)
                }
            }
            .padding()
            
            // Preview of wine occuping the slot
            .sheet(item: $selectedWineForPopup) { wine in
                VStack(spacing: 20) {
                    
                    // Title
                    Text(wine.wine_name)
                        .font(.headline)
                        .bold()
                    
                    // Img preview
                    if let urlString = wine.imageURL,
                       let url = URL(string: urlString) {
                        
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 350)
                        } placeholder: {
                            Text("Loadingggg...")
                        }
                    }
                    else{
                        Text("No image in the database yet...")
                    }
                    
                    // Extra details
                    Text("\(wine.grape) from \(wine.region) in \(wine.country_of_origin), (\(wine.vintage))")
                        .foregroundColor(.secondary)
                    
                    // Nav buttons
                    HStack {
                        Button("Dismiss") {
                            selectedWineForPopup = nil
                        }
                        .buttonStyle(.bordered)
                        .tint(.gray)
                        
                        Button("Edit Wine") {
                            onWineSelected(wine)
                            selectedWineForPopup = nil
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.blue)
                    }
                }
                .padding()
            }
        }
    }
    
    
    // MARK: - Columns per shelf
    func columns(for shelf: Int) -> [GridItem] {
        let colsPerShelf: [Int: Int] = [
            1: 9,
            2: 9,
            3: 9,
            4: 7,
            5: 9,
            6: 8
        ]
        
        let count = colsPerShelf[shelf] ?? 0
        return Array(repeating: GridItem(.flexible(), spacing: 2), count: count)
    }
    
    // MARK: - Slot generator
    func generateSlots(for shelf: Int) -> [String] {
        var slots: [String] = []
        
        let colsPerShelf: [Int: Int] = [
            1: 9,
            2: 9,
            3: 9,
            4: 7,
            5: 9,
            6: 8
        ]
        
        let columns = colsPerShelf[shelf] ?? 0
        
        for row in 1...25 {              // vertical (height)
            for column in 1...columns {  // horizontal (width)
                let id = "c\(column)-r\(row)-s\(shelf)"
                slots.append(id)
            }
        }
        
        return slots
    }
    
    func toggleSlot(_ slot: String) {
        if editableSlots.contains(slot) {
            editableSlots.remove(slot)
        } else {
            editableSlots.insert(slot)
        }
    }
    
    func wineForSlot(_ slot: String) -> Wine? {
        return wines.first { wine in
            (wine.slots ?? []).contains(slot)
        }
    }
}
