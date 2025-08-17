//
//  FavoriteManagerService.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-14.
//

import Foundation

@MainActor
final class FavoriteManagerService: ObservableObject{
    
    @Published var favorites: [Affirmation] = []
    
    private(set) var favoriteIndex: Set<String> = []
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    init() {
        loadFavorites()
    }
    
    private func favoriteKey(for affirmation: Affirmation) -> String {
        if affirmation.category == "API" {
            return formatTextForAPI(affirmation.affirmationText)
        } else {
            return affirmation.id.uuidString
        }
    }
    
    func isFavorite(affirmation: Affirmation) -> Bool {
        let key = favoriteKey(for: affirmation)
        return favoriteIndex.contains(key)
    }
    
    private func addFavorite(_ affirmation: Affirmation) {
        let key = favoriteKey(for: affirmation)
        guard !favoriteIndex.contains(key) else { return }
        favoriteIndex.insert(key)
        favorites.append(affirmation)
        saveFavorites()
    }
    
    private func removeFavorite(_ affirmation: Affirmation) {
        let key = favoriteKey(for: affirmation)
        guard favoriteIndex.contains(key) else { return }
        favoriteIndex.remove(key)
        favorites.removeAll { $0 == affirmation }
        saveFavorites()
    }
    
    func toggle(_ affirmation: Affirmation) {
        if isFavorite(affirmation: affirmation) {
            removeFavorite(affirmation)
        } else {
            addFavorite(affirmation)
        }
    }
    
    private func saveFavorites() {
        do{
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: "favorites")
        }
        catch {
            print("Error saving favorite affirmation: \(error)")
        }
    }
    
    private func formatTextForAPI(_ text: String) -> String {
        return text
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites") {
            do {
                favorites = try JSONDecoder().decode([Affirmation].self, from: data)
                favoriteIndex.removeAll()
                
                for affirmation in favorites {
                    if affirmation.category == "API" {
                        favoriteIndex.insert(formatTextForAPI(affirmation.affirmationText))
                    } else {
                        favoriteIndex.insert(affirmation.id.uuidString)
                    }
                }
            } catch {
                print("Error loading favorites: \(error)")
                favorites = []
            }
        }
    }
    
}
