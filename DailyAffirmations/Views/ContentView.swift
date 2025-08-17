//
//  ContentView.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-05.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var favoritesManager = FavoriteManagerService()
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            Tab("Category", systemImage: "newspaper"){
                CategoryListView()
            }
            Tab("Favorites", systemImage: "heart"){
                FavoritesView()
            }
        }
        .environmentObject(favoritesManager)
    }
}

#Preview {
    ContentView()
}
