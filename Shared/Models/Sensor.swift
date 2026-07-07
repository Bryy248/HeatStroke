//
//  Sensor.swift
//  HeatStroke
//
//  Created by Nabiel Ahmad Ardhityo on 07/07/26.
//

import SwiftUI

struct Sensor: Codable, Identifiable {
    let id: UUID
    let eventId: UUID
    let sensorName: String
    let latitude: Double?
    let longitude: Double?
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey{
        case id
        case eventId = "event_id"
        case sensorName = "sensor_name"
        case latitude
        case longitude
        case createdAt = "created_at"
    }
}
