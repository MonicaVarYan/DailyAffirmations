//
//  AffirmationsViewModel.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-07.
//

import Foundation

@MainActor
class AffirmationViewModel: ObservableObject {
    @Published var affirmations: [Affirmation] = []
    @Published var currentAffirmation: Affirmation?

    private let service = AffirmationService()
    
    init() {
        retrieveTodayAffirmation()
    }
    
//    func loadDayAffirmation() {
//        Task {
//            do {
//                let loaded = try await service.fetchAffirmationFromAPI()
//                DispatchQueue.main.async { [weak self] in
//                    self?.affirmations = loaded
//                    self?.currentAffirmation = loaded.randomElement()
//                }
//            } catch {
//                print("Error loading affirmations:", error)
//            }
//        }
//    }
    
    func retrieveTodayAffirmation() {
        Task {
            do {
                let todayAffirmation = try await service.retrieveDayAffirmation()
                DispatchQueue.main.async { [weak self] in
                    self?.currentAffirmation = todayAffirmation.first
                }
            }
            catch {
                print("Error loading affirmations:", error)

            }
        }
    }

    func showNewAffirmation() {
        guard !affirmations.isEmpty else { return }
        currentAffirmation = affirmations.randomElement()
    }
}
