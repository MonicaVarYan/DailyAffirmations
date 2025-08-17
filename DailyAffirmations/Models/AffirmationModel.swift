//
//  AffirmationModel.swift
//  DailyAffirmations
//
//  Created by Monica Vargas on 2025-08-06.
//

import Foundation
import SwiftUI


struct Affirmation: Encodable, Decodable, Identifiable, Equatable {
    let id: UUID
    let affirmationText: String
    let category: String
}

let affirmation = Affirmation(id: UUID(), affirmationText: "", category: "")
