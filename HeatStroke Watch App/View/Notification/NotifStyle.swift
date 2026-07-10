//
//  NotifStyle.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 09/07/26.
//

import SwiftUI

struct NotifStyle {
    let icon: String
    let tint: Color
    
    static func forCategory(_ raw: String) -> NotifStyle {
        switch NotifCategory(rawValue: raw) {
        case .high: return NotifStyle(icon: "exclamationmark.triangle.fill", tint: .orangeHigh)
        case .danger: return NotifStyle(icon: "hand.raised", tint: .red)
        case .none:
            return NotifStyle(icon: "thermometer.sun.fill", tint: .red)
        }
    }
}
