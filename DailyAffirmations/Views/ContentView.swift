//
//  ContentView.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-05.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem(){
                    Label("Home", systemImage: "house")
                }
        }
    }
}

#Preview {
    ContentView()
}
