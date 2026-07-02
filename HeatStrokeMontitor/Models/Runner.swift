//
//  Runner.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 02/07/26.
//

import Foundation
import MapKit

struct Runner: Identifiable {

    // MARK: - Identity

    let id = UUID()
    // UUID dipakai oleh SwiftUI supaya setiap Runner unik

    let bib: String
    // nomor BIB peserta marathon

    // MARK: - Physiological Data

    var heartRate: Double?
    // Heart Rate (BPM)

    var bodyTemperature: Double?
    // Body Temperature (°C)

    // MARK: - Live Location

    var coordinate: CLLocationCoordinate2D
    // lokasi runner sekarang
    // nanti berasal dari GPS HP / Apple Watch

    // MARK: - HeatGuard Result

    var heatRisk: HeatRiskLevel
    // hasil perhitungan HeatGuard
}
