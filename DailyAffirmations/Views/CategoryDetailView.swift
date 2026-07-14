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
    @State private var isBreathing = false

    var body: some View {
        ZStack {
            backgroundGradient
            breathingCircles

            VStack(spacing: 32) {
                Spacer()

                if let affirmation = currentAffirmation {
                    header(for: affirmation)

                    affirmationCard(for: affirmation)
                        .id(affirmation.id)
                        .transition(.opacity.combined(with: .scale(scale: 0.97)))

                    HStack(spacing: 20) {
                        favoriteButton(for: affirmation)
                        newAffirmationButton
                    }
                }

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            currentAffirmation = affirmations.randomElement()
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                isBreathing = true
            }
        }
        .onDisappear {
            currentAffirmation = nil
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

    /// Soft blurred shapes that slowly expand and contract, evoking a calm breathing rhythm.
    private var breathingCircles: some View {
        ZStack {
            Circle()
                .fill(Color("Accent").opacity(0.5))
                .frame(width: 280, height: 280)
                .blur(radius: 60)
                .offset(x: -120, y: -220)
                .scaleEffect(isBreathing ? 1.15 : 0.9)

            Circle()
                .fill(Color("SoftGreen").opacity(0.4))
                .frame(width: 320, height: 320)
                .blur(radius: 70)
                .offset(x: 140, y: 260)
                .scaleEffect(isBreathing ? 0.9 : 1.15)
        }
        .ignoresSafeArea()
    }

    private func header(for affirmation: Affirmation) -> some View {
        Text(affirmation.category)
            .font(.subheadline)
            .fontWeight(.semibold)
            .textCase(.uppercase)
            .tracking(3)
            .foregroundColor(Color("TextPrimary").opacity(0.6))
    }

    private func affirmationCard(for affirmation: Affirmation) -> some View {
        Text(affirmation.affirmationText)
            .font(.system(.largeTitle, design: .serif))
            .fontWeight(.medium)
            .foregroundColor(Color("TextPrimary"))
            .multilineTextAlignment(.center)
            .lineSpacing(8)
            .padding(.vertical, 40)
            .padding(.horizontal, 28)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color("Background").opacity(0.55))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(Color("Background").opacity(0.8), lineWidth: 1)
            )
            .shadow(color: Color("TextPrimary").opacity(0.08), radius: 20, x: 0, y: 10)
    }

    private func favoriteButton(for affirmation: Affirmation) -> some View {
        let isFavorite = favoritesManager.isFavorite(affirmation: affirmation)

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.5)) {
                favoritesManager.toggle(affirmation)
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 24))
                .foregroundColor(isFavorite ? Color("PrimaryColorBlue") : Color("TextPrimary").opacity(0.6))
                .scaleEffect(isFavorite ? 1.15 : 1)
                .padding(18)
                .background(
                    Circle()
                        .fill(Color("Background").opacity(0.55))
                )
        }
    }

    private var newAffirmationButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.6)) {
                currentAffirmation = affirmations.randomElement()
            }
        } label: {
            Label("New affirmation", systemImage: "sparkles")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color("TextPrimary").opacity(0.7))
                .padding(.vertical, 18)
                .padding(.horizontal, 24)
                .background(
                    Capsule()
                        .fill(Color("Background").opacity(0.55))
                )
        }
    }
}

#Preview {
    NavigationStack {
        CategoryDetailView(affirmations: [
            Affirmation(id: UUID(), affirmationText: "You are worthy and deserving of respect", category: "Self-Love")
        ])
    }
    .environmentObject(FavoriteManagerService())
}
