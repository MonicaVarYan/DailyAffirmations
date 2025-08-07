//
//  AffirmationService.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-06.
//

import Foundation

class AffirmationService {
    let affirmationAPI = URL(string: "https://www.affirmations.dev/")!
    
    func fetchAffirmationFromAPI() async throws -> [Affirmation] {
        let (data, _) = try await URLSession.shared.data(from: affirmationAPI)
        let decoder = JSONDecoder()
        let response = try decoder.decode(AffirmationAPIModel.self, from: data)
        
        let affirmationItem = Affirmation(
            id: UUID(),
            affirmationText: response.affirmation,
            category: "API",
            isFavorite: false
        )
        
        return [affirmationItem]
    }
    
    private struct APIAffirmation: Codable {
        let affirmation: String
    }
}

private struct AffirmationAPIModel: Codable {  //Used only for decodable JSON API Response and avoid error for using AffirmationModel
    let affirmation: String
}
