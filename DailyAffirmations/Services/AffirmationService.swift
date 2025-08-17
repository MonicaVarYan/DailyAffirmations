//
//  AffirmationService.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-06.
//

import Foundation

class AffirmationService {
    
    //MARK: -Private
    private let affirmationAPI = URL(string: "https://www.affirmations.dev/")!
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private(set) var affirmations: [Affirmation] = []
    private(set) var affirmationsByCategory: [String: [Affirmation]] = [:]
    
    private enum Keys {
        static let savedAffirmation = "savedAffirmation"
        static let savedDay = "savedDay"
    }
    
    //MARK: -Init
    init (){
        loadAffirmations()
    }
    
    //MARK: -Local Affirmations
    private func loadAffirmations() {
        guard let url = Bundle.main.url(forResource: "affirmation", withExtension: "json") else {
            print("Couln't find file: affirmations.json")
            return
        }
        do{
            let data = try Data(contentsOf: url)
            let affirmationsJSON = try decoder.decode([Affirmation].self, from: data)
            affirmations = affirmationsJSON
            affirmationsByCategory = Dictionary(grouping: affirmationsJSON, by: {$0.category})
        }
        catch {
            print("Error loading affirmations.json: \(error)")
        }
    }
    
    //MARK: -SaveAndGetDayAffirmation
    private func encodeAndSaveAffirmation(_ affirmation: Affirmation) {
        do {
            let data = try encoder.encode(affirmation)
            UserDefaults.standard.set(data, forKey: Keys.savedAffirmation)
            UserDefaults.standard.set(Date(), forKey: Keys.savedDay)
        } catch {
            print("Error saving affirmation: \(error)")
        }
    }
    
    private func getSavedAffirmation() -> Affirmation? {
        guard let savedData = UserDefaults.standard.data(forKey: Keys.savedAffirmation) else { return nil }
        return try? decoder.decode(Affirmation.self, from: savedData)
    }
    
    private func getRandomLocalAffirmation() -> Affirmation? {
        affirmations.randomElement()
    }
    
    
    //MARK: -Public
    func retrieveDayAffirmation() async throws -> Affirmation? {
        if let savedDate = UserDefaults.standard.object(forKey: Keys.savedDay) as? Date,
           Calendar.current.isDateInToday(savedDate),
           let savedAffirmation = getSavedAffirmation(),
           !savedAffirmation.affirmationText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return savedAffirmation
        }
        
        do {
            let apiAffirmation = try await fetchAffirmationFromAPI()
            if let affirmation = apiAffirmation.first {
                encodeAndSaveAffirmation(affirmation)
                return affirmation
            }
        } catch {
            if let localAffirmation = getRandomLocalAffirmation() {
                encodeAndSaveAffirmation(localAffirmation)
                return localAffirmation
            }
        }
        return nil
    }
    
    func fetchAffirmationFromAPI() async throws -> [Affirmation] {
        let (data, _) = try await URLSession.shared.data(from: affirmationAPI)
        let response = try decoder.decode(AffirmationAPIModel.self, from: data)
        
        let affirmationItem = Affirmation(
            id: UUID(),
            affirmationText: response.affirmation,
            category: "API"
        )
        
        encodeAndSaveAffirmation(affirmationItem)
        
        return [affirmationItem]
    }
    
    //MARK: -Private Model
    private struct AffirmationAPIModel: Codable { //Used only for decodable JSON API Response and avoid error for using AffirmationModel
        let affirmation: String
    }
}
