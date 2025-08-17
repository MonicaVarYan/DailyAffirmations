//
//  CategoryDetailView.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-12.
//

import SwiftUI

struct CategoryDetailView: View {
    @EnvironmentObject var favoritesManager: FavoriteManagerService
    
    let affirmations: [Affirmation]
    @State private var currentAffirmation: Affirmation?
    
    var body: some View {
        VStack{
            if let randomAffirmation = currentAffirmation{
                Text(randomAffirmation.affirmationText)
                    .navigationTitle(randomAffirmation.category)
                Button("fav", systemImage:favoritesManager.isFavorite(affirmation: randomAffirmation) ? "heart.fill" : "heart", action: {
                    favoritesManager.toggle(randomAffirmation)
                })
                .labelStyle(.iconOnly)
                .font(.system(size: 26))
                Button("New Affirmation") {
                    currentAffirmation = affirmations.randomElement()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .onAppear {
            currentAffirmation = affirmations.randomElement()
        }
        .onDisappear {
            currentAffirmation = nil
        }
    }
}

#Preview {
    CategoryDetailView(affirmations: [])
}
