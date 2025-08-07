//
//  HomeView.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-05.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color("Primary").edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
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
                
            }
            .padding(.bottom, 500)
        }
    }
}

#Preview {
    HomeView()
}
