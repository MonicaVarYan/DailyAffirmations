//
//  SplashView.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2026-07-14.
//

import SwiftUI

struct SplashView: View {
    @State private var showContent = false
    @State private var isBreathing = false

    var body: some View {
        ZStack {
            backgroundGradient
            breathingCircles

            VStack(spacing: 20) {
                Image(systemName: "sun.max")
                    .font(.system(size: 36))
                    .foregroundColor(Color("TextPrimary").opacity(0.7))
                    .padding(24)
                    .background(
                        Circle()
                            .fill(Color("Background").opacity(0.55))
                    )
                    .scaleEffect(showContent ? 1 : 0.8)

                Text("Daily Affirmations")
                    .font(.system(.largeTitle, design: .serif))
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextPrimary"))

                Text("Un momento para ti")
                    .font(.footnote)
                    .textCase(.uppercase)
                    .tracking(3)
                    .foregroundColor(Color("TextPrimary").opacity(0.5))
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 16)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                showContent = true
            }
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                isBreathing = true
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
}

#Preview {
    SplashView()
}
