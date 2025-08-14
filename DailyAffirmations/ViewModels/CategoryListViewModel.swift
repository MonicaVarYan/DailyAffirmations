//
//  CategoryListViewModel.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-09.
//

import Foundation

class CategoryListViewModel: ObservableObject {
    //MARK: -Public Vars
    @Published var fullCategories: [String: [Affirmation]] = [:]
    
    //MARK: -Private
    private let service: AffirmationService
    
    //MARK: -Init
    init(service: AffirmationService) {
        self.service = service
        fetchCategories()
    }
    
    private func fetchCategories() {
        fullCategories = service.affirmationsByCategory
    }
}
