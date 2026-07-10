//
//  FinishViewModel.swift
//  HeatStroke
//
//  Created by Brian Chang on 08/07/26.
//

import SwiftUI
internal import PostgREST
import Supabase

@Observable
class FinishViewModel {
    enum FinishType {
        case finish
        case finishWithAlert
        case stopEarly
    }
    
    enum RiskLevel: String {
        case easy
        case moderate
        case high
        case danger

        var displayName: String {
            switch self {
            case .easy:     "Safe"
            case .moderate: "Moderate"
            case .high:     "High"
            case .danger:   "Danger"
            }
        }
    }
    
    var finishDuration = ""
    var riskLevel: RiskLevel = .easy
    
    var didStopEarly = false // nanti ambil data apakah stop early atau engga
    
    var finishState: FinishType {
        if didStopEarly {
            return .stopEarly
        }
        switch riskLevel {
        case .easy, .moderate:
            return .finish
        case .high, .danger:
            return .finishWithAlert
        }
    }
    
    @MainActor
    func fetchFinishData(runnerId: UUID) async {
        do {
            let runners: [Runner] = try await SupabaseManager.client
                .from("runners")
                .select()
                .eq("id", value: runnerId)
                .execute()
                .value
            
            guard let runner = runners.first else {
                print("Runner Tidak Ditemukan")
                return
            }
            
            if let start = runner.startTime, let finish = runner.finishTime {
                finishDuration = Self.formatDuration(from: start, to: finish)
            }
            
            riskLevel = RiskLevel(rawValue: runner.currentRiskLevel ?? "") ?? .easy
            
        }
        catch {
            print("Gagal Mengambil data")
        }
    }
}

extension FinishViewModel {
    var content: FinishContent {
        switch finishState {
        case .finish:
            FinishContent(
                iconName: "trophy.fill", iconColor: .color1,
                circleBackground: .inputBgcolor,
                title: "You did it!", subtitleColor: .color1,
                finishTime: finishDuration,
                avgZone: riskLevel.displayName,
                statBackground: .inputBgcolor,
                message: "Stayed safe the whole race!",
                messageColor: .color1, buttonTint: .color1
            )
        case .finishWithAlert:
            FinishContent(
                iconName: "trophy.fill", iconColor: .color1,
                circleBackground: .inputBgcolor,
                title: "You did it!", subtitleColor: .color1,
                finishTime: finishDuration,
                avgZone: riskLevel.displayName,
                statBackground: .inputBgcolor,
                message: "Made it, but heat risk rose twice. Rest and hydrate well.",
                messageColor: .yellow, buttonTint: .color1
            )
        case .stopEarly:
            FinishContent(
                iconName: "square", iconColor: .red,
                circleBackground: .finish,
                title: "Stopped early", subtitleColor: .red,
                finishTime: finishDuration,
                avgZone: riskLevel.displayName,
                statBackground: .gray.opacity(0.2),
                message: "Good call stopping. Rest, hydrate, see medical if needed.",
                messageColor: .red, buttonTint: .red
            )
        }
    }
    
    static func formatDuration(from start: Date, to finish: Date) -> String {
            let seconds = Int(finish.timeIntervalSince(start))   // selisih dalam detik
            let h = seconds / 3600
            let m = (seconds % 3600) / 60
            let s = seconds % 60
            return String(format: "%d:%02d:%02d", h, m, s)       // "2:30:08"
        }
}
