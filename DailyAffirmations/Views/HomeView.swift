//
//  HomeView.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-05.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = AffirmationViewModel(service: AffirmationService())
    @EnvironmentObject var favoritesManager: FavoriteManagerService

    var body: some View {
        ZStack {
            Color("Primary").edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                if viewModel.isLoading {
                    ProgressView("Loading Affirmation...")
                } else if let affirmation = viewModel.dailyAffirmation {
                    Text("Afirmación del Día")
                        .font(.title)
                        .foregroundColor(Color("Background"))
                    
                    Text(affirmation.affirmationText)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(Color("TextPrimary"))
                        .padding()
                        .background(Color("Secondary"))
                        .cornerRadius(20)
                        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 30)
                    Button("fav", systemImage:favoritesManager.isFavorite(affirmation: affirmation) ? "heart.fill" : "heart", action: {
                        favoritesManager.toggle(affirmation)
                        print ("Favoritos tapped")
                    })
                        .labelStyle(.iconOnly)
                        .font(.system(size: 26))
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding(.bottom, 500)
        }
        .task {
            await viewModel.loadDayAffirmation()
        }
    }
}

#Preview {
    HomeView()
}


