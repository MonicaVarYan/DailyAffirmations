//
//  FavoritesView.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-16.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoriteManagerService
    @State private var affirmationToDelete: Affirmation? = nil
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(favoritesManager.favorites) { affirmation in
                    HStack {
                        Text(affirmation.affirmationText)
                        
                        Spacer()
                        Button {
                            affirmationToDelete = affirmation
                            showAlert = true
                        } label: {
                            Image(systemName: "heart.fill")
                        }
                        .font(.system(size: 20))
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Favorites")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Favorite"),
                    message: Text("Are you sure you want to delete this favorite?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let affirmation = affirmationToDelete {
                            favoritesManager.toggle(affirmation)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

#Preview {
    FavoritesView()
}
