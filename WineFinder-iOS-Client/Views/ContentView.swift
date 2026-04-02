//
//  ContentView.swift
//  WineFinder-iOS-Client
//
//  Created by Pawel Krezel on 31/03/2026.
//
import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = WineViewModel()
    @State private var showingAdd = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.wines) { wine in
                    NavigationLink(
                        destination: WineFormView(
                            viewModel: viewModel,
                            wine: wine
                        )
                    ) {
                        VStack(alignment: .leading) {
                            Text(wine.wine_name)
                            Text("\(wine.vintage) • \(wine.region)")
                        }
                    }
                }
                .onDelete { indexSet in
                    viewModel.deleteWine(at: indexSet)
                }
            }
            .navigationTitle("Wines")
            .navigationBarItems(trailing:
                Button("+") {
                    showingAdd = true
                }
            )
            .sheet(isPresented: $showingAdd) {
                WineFormView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadWines()
            }
        }
    }
}

#Preview {
    ContentView()
}
