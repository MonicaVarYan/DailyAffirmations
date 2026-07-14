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

    @State private var showAffirmation = false
    @State private var isBreathing = false

    var body: some View {
        ZStack {
            backgroundGradient
            breathingCircles

            VStack(spacing: 32) {
                Spacer()

                if viewModel.isLoading {
                    ProgressView("Loading affirmation...")
                        .tint(Color("TextPrimary"))
                        .foregroundColor(Color("TextPrimary"))
                } else if let affirmation = viewModel.dailyAffirmation {
                    header

                    affirmationCard(for: affirmation)

                    favoriteButton(for: affirmation)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.callout)
                        .foregroundColor(Color("TextPrimary"))
                        .padding()
                }

                Spacer()
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .task {
            await viewModel.loadDayAffirmation()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                isBreathing = true
            }
        }
        .onChange(of: viewModel.dailyAffirmation?.id) {
            withAnimation(.easeOut(duration: 1.2)) {
                showAffirmation = true
            }
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

    private var header: some View {
        VStack(spacing: 8) {
            Text("Daily Affirmation")
                .font(.subheadline)
                .fontWeight(.semibold)
                .textCase(.uppercase)
                .tracking(3)
                .foregroundColor(Color("TextPrimary").opacity(0.6))

            Text(Date.now.formatted(.dateTime.month(.twoDigits).day(.twoDigits).year()))
                .font(.footnote)
                .foregroundColor(Color("TextPrimary").opacity(0.4))
        }
        .opacity(showAffirmation ? 1 : 0)
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
            .opacity(showAffirmation ? 1 : 0)
            .offset(y: showAffirmation ? 0 : 24)
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
        .opacity(showAffirmation ? 1 : 0)
    }
}

#Preview {
    HomeView()
        .environmentObject(FavoriteManagerService())
}
