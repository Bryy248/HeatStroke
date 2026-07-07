//
//  Event.swift
//  HeatStroke
//
//  Created by Nabiel Ahmad Ardhityo on 05/07/26.
//

import SwiftUI

struct Event: Codable, Identifiable {
    let id: UUID
    let name: String
    let location: String?
    let startTime: String?
    let endTime: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
        case startTime = "start_time"
        case endTime = "end_time"
        case createdAt = "created_at"
    }
}
