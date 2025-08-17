//
//  CategoryListView.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-06.
//

import SwiftUI

struct CategoryListView: View {
    @StateObject private var viewModel = CategoryListViewModel(service: AffirmationService())
    
    var body: some View {
        ZStack {
            NavigationView {
                List(viewModel.fullCategories.sorted(by: {$0.key < $1.key}), id: \.key) { category in
                    NavigationLink(
                        destination: CategoryDetailView(
                            affirmations: category.value
                        )
                    ) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.blue)
                                .frame(width: 70)
                            Text(category.key)
                                .font(.headline)
                        }
                        .frame(height: 80)
                    }
                }
                .navigationTitle("Categories")
            }
        }
    }
}

#Preview {
    CategoryListView()
}
