//
//  HeatRiskLevel.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 02/07/26.
//

import SwiftUI

// HeatRiskLevel
// dipakai untuk menunjukkan tingkat bahaya heat stress seorang runner
// nanti akan dipakai untuk:
// 1. warna marker
// 2. notifikasi
// 3. tampilan di dashboard

enum HeatRiskLevel: String { //jenis heat risk level yang ada pake enum soalnya ini "satu hal yang sama" dengan rawa valuenya string

    case safe
    case risk
    case highRisk
    case veryHighRisk

    var color: Color {
        switch self {
        case .safe:
            return .green
        case .risk:
            return .yellow
        case .highRisk:
            return .orange
        case .veryHighRisk:
            return .red
        }
    }
}

