import SwiftUI

struct CellarView: View {
    let wines: [Wine]
    let selectedWine: Wine?
    @Binding var editableSlots: Set<String>
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
                                        occupiedSlots.contains(slot) ? Color.green :
                                        Color.gray.opacity(0.3)
                                    )
                                    .frame(width: 18, height: 18)
                                    .onTapGesture {
                                        toggleSlot(slot)
                                    }
                            }
                        }
                    }
                    
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 10)
                }
            }
            .padding()
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
}
