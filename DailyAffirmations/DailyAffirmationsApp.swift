//
//  DailyAffirmationsApp.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-05.
//

import SwiftUI

@main
struct DailyAffirmationsApp: App {
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()

                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .task {
                try? await Task.sleep(for: .seconds(2))
                withAnimation(.easeOut(duration: 0.8)) {
                    showSplash = false
                }
            }
        }
    }
}
