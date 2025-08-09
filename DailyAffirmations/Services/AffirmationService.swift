//
//  AffirmationService.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-06.
//

import Foundation

class AffirmationService {
    let affirmationAPI = URL(string: "https://www.affirmations.dev/")!
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    func retrieveDayAffirmation() async throws -> [Affirmation] {
        let savedDate = UserDefaults.standard.object(forKey: "savedDay") as? Date
        let savedAffirmation =  UserDefaults.standard.object(forKey: "savedAffirmation") as? Data
        
        guard let savedDate else {
            print("No Saved Date")
            do{
                let newAffirmation = try await fetchAffirmationFromAPI()
                return newAffirmation
            }catch {
                print("Getting local affirmation")
                guard let newLocalAffirmation = fecthAffirmationLocal().randomElement() else {
                    print("Error getting local affirmation")
                    return []
                }
                let affirmationData = try encoder.encode(newLocalAffirmation)
                UserDefaults.standard.set(affirmationData, forKey: "savedAffirmation")
                UserDefaults.standard.set(Date(), forKey: "savedDay")
                return [newLocalAffirmation]
            }
        }
        
        if Calendar.current.isDateInToday(savedDate){
            print("Si hay fecha guardada.")
            
            guard let savedAffirmation else {
                print("No hay afirmacion guardada.")
                do{
                    let newAffirmation = try await fetchAffirmationFromAPI()
                    return newAffirmation
                }catch {
                    print("Error decoding saved affirmation: \(error)")
                    return []
                }
            }
            let decoder = JSONDecoder()
            print("Si hay afirmacion guardada")
            let affirmation = try decoder.decode(Affirmation.self, from: savedAffirmation)
            if affirmation.affirmationText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                print("Hay afirmacion pero vacia")
                do{
                    let newAffirmation = try await fetchAffirmationFromAPI()
                    return newAffirmation
                }catch {
                    print("Error decoding saved affirmation: \(error)")
                    return []
                }
            }
            return [affirmation]
        } else {
            do{
                let newAffirmation = try await fetchAffirmationFromAPI()
                return newAffirmation
            }catch {
                print("Error decoding saved affirmation: \(error)")
                return []
            }
        }
    }
    
    func fecthAffirmationLocal() -> [Affirmation] {
        guard let url = Bundle.main.url(forResource: "affirmation", withExtension: "json") else {
            print("No se encontró el archivo affirmations.json")
            return []
        }
        do{
            let data = try Data(contentsOf: url)
            let affirmationsJSON = try decoder.decode([Affirmation].self, from: data)
            return affirmationsJSON
        }
        catch {
            print("Error cargando affirmations.json: \(error)")
            return []
        }
        
    }
    
    func fetchAffirmationFromAPI() async throws -> [Affirmation] {
        let (data, _) = try await URLSession.shared.data(from: affirmationAPI)
        let response = try decoder.decode(AffirmationAPIModel.self, from: data)
        
        let affirmationItem = Affirmation(
            id: UUID(),
            affirmationText: response.affirmation,
            category: "API",
            isFavorite: false
        )
        
        let affirmationData = try encoder.encode(affirmationItem)
        UserDefaults.standard.set(affirmationData, forKey: "savedAffirmation")
        UserDefaults.standard.set(Date(), forKey: "savedDay")
        
        return [affirmationItem]
    }
    
    private struct AffirmationAPIModel: Codable { //Used only for decodable JSON API Response and avoid error for using AffirmationModel
        let affirmation: String
    }
}
