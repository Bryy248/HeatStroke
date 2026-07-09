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
    let averageTemperature: Double
    let averageHumidity: Double
    let heatIndex: Double
    let heatIndexScore: Double
    let heartRateScore: Double
    let bodyTemperature: Double
    let finalRiskScore: Double // skor untuk mendeteksi risk level
    let riskLevel: String // safe, moderate, caution, danger
    let calculatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case runnerId = "runner_id"
        case averageTemperature = "average_temperature"
        case averageHumidity = "average_humidity"
        case heatIndex = "heat_index"
        case heatIndexScore = "heat_index_score"
        case heartRateScore = "heart_rate_score"
        case bodyTemperature = "body_temperature"
        case finalRiskScore = "final_risk_score"
        case riskLevel = "risk_level"
        case calculatedAt = "calculated_at"
    }
}
