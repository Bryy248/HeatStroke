//
//  RiskCalculation.swift
//  HeatStroke
//
//  Created by Nabiel Ahmad Ardhityo on 08/07/26.
//

import SwiftUI

struct RiskCalculation: Codable, Identifiable {
    let id: UUID
    let runnerId: UUID
    let sensorReadingId: UUID?
    let heartRate: Double
    let bodyTemperatureC: Double
    let heatIndexC: Double
    let heartRateScore: Int
    let bodyTemperatureScore: Int
    let heatIndexScore: Int // dari suhu dan humidity
    let totalScore: Int // jumlah skor2
    let riskLevel: String
    let calculatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case runnerId = "runner_id"
        case sensorReadingId = "sensor_reading_id"
        case heartRate = "heart_rate"
        case bodyTemperatureC = "body_temperature_c"
        case heatIndexC = "heat_index_c"
        case heartRateScore = "heart_rate_score"
        case bodyTemperatureScore = "body_temperature_score"
        case heatIndexScore = "heat_index_score"
        case totalScore = "total_score"
        case riskLevel = "risk_level"
        case calculatedAt = "calculated_at"
    }
}
