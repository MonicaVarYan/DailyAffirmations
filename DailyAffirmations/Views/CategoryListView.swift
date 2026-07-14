//
//  CategoryListView.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-06.
//

import SwiftUI

struct CategoryListView: View {
    @StateObject private var viewModel = CategoryListViewModel(service: AffirmationService())

    @State private var showContent = false

    private var sortedCategories: [(key: String, value: [Affirmation])] {
        viewModel.fullCategories.sorted(by: { $0.key < $1.key })
    }

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                ScrollView {
                    VStack(spacing: 16) {
                        header
                            .padding(.top, 24)
                            .padding(.bottom, 16)

                        ForEach(Array(sortedCategories.enumerated()), id: \.element.key) { index, category in
                            NavigationLink(
                                destination: CategoryDetailView(affirmations: category.value)
                            ) {
                                categoryCard(name: category.key, count: category.value.count)
                            }
                            .buttonStyle(.plain)
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
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            showContent = true
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
            Text("Categories")
                .font(.subheadline)
                .fontWeight(.semibold)
                .textCase(.uppercase)
                .tracking(3)
                .foregroundColor(Color("TextPrimary").opacity(0.6))

            Text("Choose a theme for your moment of calm")
                .font(.footnote)
                .foregroundColor(Color("TextPrimary").opacity(0.4))
        }
        .frame(maxWidth: .infinity)
    }

    private func categoryCard(name: String, count: Int) -> some View {
        HStack(spacing: 16) {
            Image(systemName: symbol(for: name))
                .font(.system(size: 20))
                .foregroundColor(Color("TextPrimary").opacity(0.7))
                .frame(width: 48, height: 48)
                .background(
                    Circle()
                        .fill(tint(for: name).opacity(0.6))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(.headline, design: .serif))
                    .foregroundColor(Color("TextPrimary"))

                Text("\(count) affirmations")
                    .font(.footnote)
                    .foregroundColor(Color("TextPrimary").opacity(0.5))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color("TextPrimary").opacity(0.3))
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

    // MARK: - Category Styling

    private func symbol(for category: String) -> String {
        switch category {
        case "Confidence": return "sun.max"
        case "Gratitude": return "sparkles"
        case "Mindfulness": return "leaf"
        case "Motivation": return "flame"
        case "Resilience": return "mountain.2"
        case "Self-Love": return "heart"
        default: return "quote.opening"
        }
    }

    private func tint(for category: String) -> Color {
        switch category {
        case "Confidence": return Color("Accent")
        case "Gratitude": return Color("Secondary")
        case "Mindfulness": return Color("SoftGreen")
        case "Motivation": return Color("Accent")
        case "Resilience": return Color("Primary")
        case "Self-Love": return Color("Secondary")
        default: return Color("Primary")
        }
    }
}

#Preview {
    CategoryListView()
        .environmentObject(FavoriteManagerService())
}
