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
    @State private var showContent = false

    var body: some View {
        ZStack {
            backgroundGradient

            if favoritesManager.favorites.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        header
                            .padding(.top, 24)
                            .padding(.bottom, 16)

                        ForEach(Array(favoritesManager.favorites.enumerated()), id: \.element.id) { index, affirmation in
                            favoriteCard(for: affirmation)
                                .opacity(showContent ? 1 : 0)
                                .offset(y: showContent ? 0 : 24)
                                .animation(
                                    .easeOut(duration: 0.7).delay(Double(index) * 0.08),
                                    value: showContent
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
        }
        .onAppear {
            showContent = true
        }
        .alert("Delete Favorite", isPresented: $showAlert) {
            Button("Delete", role: .destructive) {
                if let affirmation = affirmationToDelete {
                    withAnimation(.easeOut(duration: 0.4)) {
                        favoritesManager.toggle(affirmation)
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this favorite?")
        }
    }

    // MARK: - Subviews

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color("Primary"),
                Color("Secondary"),
                Color("Background")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text("Favorites")
                .font(.subheadline)
                .fontWeight(.semibold)
                .textCase(.uppercase)
                .tracking(3)
                .foregroundColor(Color("TextPrimary").opacity(0.6))

            Text("The affirmations you saved for yourself")
                .font(.footnote)
                .foregroundColor(Color("TextPrimary").opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart")
                .font(.system(size: 40))
                .foregroundColor(Color("TextPrimary").opacity(0.3))
                .padding(24)
                .background(
                    Circle()
                        .fill(Color("Background").opacity(0.55))
                )

            Text("No favorites yet")
                .font(.system(.headline, design: .serif))
                .foregroundColor(Color("TextPrimary").opacity(0.7))

            Text("Tap the heart on an affirmation\nto save it here")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("TextPrimary").opacity(0.4))
        }
    }

    private func favoriteCard(for affirmation: Affirmation) -> some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(affirmation.affirmationText)
                    .font(.system(.body, design: .serif))
                    .foregroundColor(Color("TextPrimary"))
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)

                Text(affirmation.category)
                    .font(.caption)
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundColor(Color("TextPrimary").opacity(0.4))
            }

            Spacer()

            Button {
                affirmationToDelete = affirmation
                showAlert = true
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color("PrimaryColorBlue"))
                    .padding(12)
                    .background(
                        Circle()
                            .fill(Color("Background").opacity(0.55))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color("Background").opacity(0.55))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color("Background").opacity(0.8), lineWidth: 1)
        )
        .shadow(color: Color("TextPrimary").opacity(0.06), radius: 12, x: 0, y: 6)
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoriteManagerService())
}
