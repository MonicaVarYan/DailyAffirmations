//
//  CategoryView.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-06.
//

import SwiftUI

struct CategoryView: View {
    var body: some View {
        ZStack {
            List{
                Text("Hello, World!")
                    .padding(10)
                Text("Hello, World!")
                    .padding(10)
            }
            .scrollContentBackground(.hidden)
            .background(Color("Primary"))
        }
    }
}

#Preview {
    CategoryView()
}
