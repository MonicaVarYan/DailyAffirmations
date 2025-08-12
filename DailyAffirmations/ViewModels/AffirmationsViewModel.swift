//
//  AffirmationsViewModel.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-07.
//

import Foundation

@MainActor
class AffirmationViewModel: ObservableObject {
    //MARK: -Public Vars
    @Published var dailyAffirmation: Affirmation?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    //MARK: -Private
    private let service: AffirmationService
    
    //MARK: -Init
    init(service: AffirmationService) {
        self.service = service
    }
    
    //MARK: -Public functions
    func loadDayAffirmation() async {
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let affirmations = try await service.retrieveDayAffirmation()
            self.dailyAffirmation = affirmations
        } catch {
            self.errorMessage = "Error fetching affirmation: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
