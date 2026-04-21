//
//  MainView.swift
//  WineFinder-iOS-Client
//
//  Created by Pawel Krezel on 02/04/2026.
//
import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = WineViewModel()
    
    @State private var selectedWine: Wine?
    @State private var showingAdd = false
    
    var body: some View {
        NavigationSplitView {
            
            // LEFT PANEL (LIST)
            List(selection: $selectedWine) {
                ForEach(viewModel.wines) { wine in
                    VStack(alignment: .leading) {
                        Text(wine.wine_name)
                            .font(.headline)
                        
                        Text("\(wine.vintage) • \(wine.region)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .tag(wine)
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        let wine = viewModel.wines[index]
                        viewModel.deleteWine(id: wine.id)
                    }
                }
            }
            .navigationTitle("Wines")
            .toolbar {
                Button {
                    showingAdd = true
                } label: {
                    Label("Add Wine", systemImage: "plus")
                }
            }
            
            
        } detail: {
            
            // RIGHT PANEL (DETAIL)
            if let wine = selectedWine {
                VStack {
                    WineFormView(
                        viewModel: viewModel,
                        wine: wine
                    )
                    .id(wine.id)
                }
            } else {
                Text("Select a wine")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            viewModel.loadWines()
        }
        .sheet(isPresented: $showingAdd) {
            WineFormView(
                viewModel: viewModel,
                wine: nil
            )
        }
    }
}
