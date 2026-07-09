//
//  SensorReading.swift
//  HeatStroke
//
//  Created by Nabiel Ahmad Ardhityo on 08/07/26.
//

import SwiftUI

struct SensorReading: Codable, Identifiable {
    let id: UUID
    let sensorId: UUID
    let temperature: Double
    let humidity: Double
    let recordedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case sensorId = "sensor_id"
        case temperature
        case humidity
        case recordedAt = "recorded_at"
    }
}
