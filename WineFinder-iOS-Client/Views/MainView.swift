//
//  MainView.swift
//  WineFinder-iOS-Client
//
//  Created by Pawel Krezel on 02/04/2026.
//
import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = WineViewModel()
    
    @State private var searchText = ""
    @State private var showingAdd = false
    
    var filteredWines: [Wine] {
        if searchText.isEmpty {
            return viewModel.wines
        }
        
        let query = searchText.lowercased()
        return viewModel.wines.filter { wine in
            wine.wine_name.lowercased().contains(query) ||
            wine.grape.lowercased().contains(query) ||
            wine.region.lowercased().contains(query) ||
            wine.country_of_origin.lowercased().contains(query) ||
            String(wine.vintage).contains(query) ||
            wine.body.lowercased().contains(query) ||
            wine.acidity.lowercased().contains(query) ||
            wine.tannin.lowercased().contains(query)
        }
    }
    
    var body: some View {
        NavigationSplitView {
            
            // LEFT PANEL (LIST)
            if viewModel.isLoading {
                ProgressView("Loading/Updating wines...")
            } else {
                List(selection: $viewModel.selectedWine) {
                    ForEach(filteredWines) { wine in
                        VStack(alignment: .leading) {
                            Text(wine.wine_name)
                                .font(.headline)
                            
                            Text("\(wine.vintage) • \(wine.region), \(wine.country_of_origin)")
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
                    
                    if !searchText.isEmpty && filteredWines.isEmpty {
                        Text("Womp! Womp! No results found")
                            .foregroundColor(.gray)
                    }
                }
                .searchable(text: $searchText, prompt: "Search by wine attributes")
                .navigationTitle("Wines")
                .toolbar {
                    Button {
                        showingAdd = true
                    } label: {
                        Label("Add Wine", systemImage: "plus")
                    }
                }
            }

            
            
        } detail: {
            // RIGHT PANEL (DETAIL)
            if let wine = viewModel.selectedWine {
                VStack {
                    WineFormView(viewModel: viewModel, isAddMode: false)
                }
            } else {
                Text("Select a wine from the list, or add a new entry")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            viewModel.isLoading = true
            viewModel.loadWines()
        }
        .sheet(isPresented: $showingAdd) {
            WineFormView(viewModel: viewModel, isAddMode: true)
        }
    }
}
