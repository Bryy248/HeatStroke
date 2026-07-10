//
//  HeatStrokeRiskCalculator.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 03/07/26.
//

import Foundation

enum RiskLevel: Int, Comparable {
    case safe = 0
    case moderate = 1
    case high = 2
    case veryHigh = 3

    static func < (lhs: RiskLevel, rhs: RiskLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var label: String {
        switch self {
        case .safe: return "Safe"
        case .moderate: return "Moderate"
        case .high: return "High"
        case .veryHigh: return "Very High"
        }
    }
}

struct HeatStrokeRiskCalculator {

    // Heat Index (Awasthi, Vishwakarma & Pattnayak, 2021 — dipakai di paper, T & RH dalam Celsius/persen)
    static func heatIndex(temperature T_celsius: Double, humidity RH: Double) -> Double {
        // Formula Rothfusz regression (NOAA/NWS) HANYA valid untuk input Fahrenheit.
        // Konversi dulu, hitung, baru konversi hasilnya balik ke Celsius.
        let T = T_celsius * 9.0 / 5.0 + 32.0

        let hiFahrenheit = -42.379
            + 2.04901523 * T
            + 10.14333127 * RH
            - 0.22475541 * T * RH
            - 0.00683783 * T * T
            - 0.05481717 * RH * RH
            + 0.00122874 * T * T * RH
            + 0.00085282 * T * RH * RH
            - 0.00000199 * T * T * RH * RH

        return (hiFahrenheit - 32.0) * 5.0 / 9.0
    }
    
    enum SkinSite {
        case rectal, head, torso, hand, foot

        /// Selisih tipikal (core − suhu kulit) di lokasi ini saat istirahat, dalam °C.
        /// Makin perifer (tangan/kaki), makin dingin, jadi selisihnya makin besar.
        var baseOffset: Double {
            switch self {
            case .rectal: return 0.0   // ini praktis sudah core
            case .torso:  return 1.0
            case .head:   return 1.5
            case .hand:   return 2.5   // pergelangan/tangan
            case .foot:   return 3.5
            }
        }
    }


    /// Estimasi core body temperature dari suhu kulit (wrist/hand) + ambient.
    /// Formula: T_core = T_skin + α × (T_skin - T_ambient)
    static func estimatedCoreTemperature(skinTemperature skin: Double,
                                         ambientTemperature ambient: Double,
                                         site: SkinSite = .hand) -> Double {
        // Di atas ambang nyaman (~33°C), pembuangan panas terhambat -> core naik.
        // Di bawah itu, lingkungan dingin TIDAK menaikkan estimasi core.
        let comfortAmbient = 33.0
        let heatGain = 0.25 * max(0, ambient - comfortAmbient)

        let raw = skin + site.baseOffset + heatGain

        // Jaring pengaman: manusia hidup ada di ~35,5–42°C.
        return min(max(raw, 35.5), 42.0)
    }

    // MARK: - Skor per komponen (skala mengikuti paper baru: Table 2, 4, 5)

    static func heartRateScore(percentHRmax: Double) -> Int {
        switch percentHRmax {
        case ..<60: return 0    // 0-59%
        case 60..<80: return 2  // 60-80%
        case 80..<90: return 4  // 80-90%
        default: return 6       // 90-100%
        }
    }

    static func coreTemperatureScore(celsius: Double) -> Int {
        switch celsius {
        case ..<38.0: return 0    // 36.5-37.5 (gap 37.6-37.9 ikut di sini, lihat catatan)
        case 38.0..<41.0: return 11 // 38.0-40.0 (gap 40.1-40.9 ikut di sini)
        default: return 22          // >=41.0
        }
    }

    static func heatIndexScore(_ hi: Double) -> Int {
        switch hi {
        case ..<33: return 0    // <=32
        case 33..<42: return 2  // 33-41
        case 42..<52: return 4  // 42-51
        default: return 6       // >51
        }
    }

    /// Estimasi HRmax pakai formula Tanaka (2001) — lebih akurat dari 220-age untuk dewasa.
    static func estimatedMaxHeartRate(age: Int) -> Double {
        208.0 - (0.7 * Double(age))
    }

    static func percentOfMaxHeartRate(bpm: Double, age: Int) -> Double {
        let maxHR = estimatedMaxHeartRate(age: age)
        guard maxHR > 0 else { return 0 }
        return (bpm / maxHR) * 100
    }

    /// Total = sum semua skor komponen, dipetakan ke status akhir via Table 7.
    /// (Galvanic Skin Response sengaja tidak diikutkan — sensornya tidak tersedia.)
    static func overallRisk(heartRateBPM: Double, age: Int, coreTemperatureC: Double, heatIndexC: Double) -> RiskLevel {
        let percentHRmax = percentOfMaxHeartRate(bpm: heartRateBPM, age: age)

        let total = heartRateScore(percentHRmax: percentHRmax)
            + coreTemperatureScore(celsius: coreTemperatureC)
            + heatIndexScore(heatIndexC)

        switch total {
        case 0...4: return .safe
        case 5...14: return .moderate
        case 15...24: return .high
        default: return .veryHigh   // 31-40
        }
    }
}
