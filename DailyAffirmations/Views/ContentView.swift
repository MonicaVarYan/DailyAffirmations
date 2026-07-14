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
        Group {
            if #available(iOS 26.0, *) {
                tabView
                    .tabBarMinimizeBehavior(.onScrollDown)
            } else {
                tabView
            }
        }
        .environmentObject(favoritesManager)
    }

    private var tabView: some View {
        TabView {
            Tab("Home", systemImage: "sun.max") {
                HomeView()
                    .transparentTabBar()
            }
            Tab("Categories", systemImage: "square.grid.2x2"){
                CategoryListView()
                    .transparentTabBar()
            }
            Tab("Favorites", systemImage: "heart"){
                FavoritesView()
                    .transparentTabBar()
            }
        }
        .tint(Color("PrimaryColorBlue"))
    }
}

private extension View {
    /// Keeps the tab bar transparent on iOS 18 and earlier, where a scroll view
    /// behind the bar would otherwise give it an opaque background.
    /// On iOS 26 the system's Liquid Glass bar is left untouched.
    @ViewBuilder
    func transparentTabBar() -> some View {
        if #available(iOS 26.0, *) {
            self
        } else {
            self.toolbarBackground(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    ContentView()
}
