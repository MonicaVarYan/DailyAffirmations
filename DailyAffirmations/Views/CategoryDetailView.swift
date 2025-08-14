//
//  CategoryDetailView.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-12.
//

import SwiftUI

struct CategoryDetailView: View {
    let categoryName: String
    let onlyAffirmation: Affirmation?
        
        var body: some View {
            Text(onlyAffirmation?.affirmationText ?? "")
            .navigationTitle(categoryName)
        }
}

#Preview {
    CategoryDetailView(categoryName: "Self-Love", onlyAffirmation: nil)
}
