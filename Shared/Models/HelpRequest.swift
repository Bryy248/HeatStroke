//
//  HelpRequest.swift
//  HeatStroke
//
//  Created by Nabiel Ahmad Ardhityo on 08/07/26.
//

import SwiftUI

struct HelpRequest: Codable, Identifiable {
    let id: UUID
    let runnerId: UUID
    let eventId: UUID
    let requestedAt: Date
    let latitude: Double?
    let longitude: Double?
    let status: String
    let riskLevelAtRequest: String
    let marshalId: UUID?
    let respondedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case runnerId = "runner_id"
        case eventId = "event_id"
        case requestedAt = "requested_at"
        case latitude
        case longitude
        case status
        case riskLevelAtRequest = "risk_level_at_request"
        case marshalId = "marshalId"
        case respondedAt = "responded_at"
    }
}
