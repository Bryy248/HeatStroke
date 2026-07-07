//
//  Runner.swift
//  HeatStroke
//
//  Created by Nabiel Ahmad Ardhityo on 04/07/26.
//

import SwiftUI

struct Runner: Codable, Identifiable {
    let id: UUID
    let eventId: UUID
    let name: String
    let bibNumber: String
    let age: Int?
    let birthDate: String?
    let gender: String?
    let currentRiskLevel: String?
    let lastUpdated: String?
    let createdAt: String?
    let registeredBy: UUID?

    enum CodingKeys: String, CodingKey {
        case id
        case eventId = "event_id"
        case name
        case bibNumber = "bib_number"
        case age
        case birthDate = "birth_date"
        case gender
        case currentRiskLevel = "current_risk_level"
        case lastUpdated = "last_updated"
        case createdAt = "created_at"
        case registeredBy = "registered_by"
    }
}
