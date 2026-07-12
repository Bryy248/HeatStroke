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

    var finishDuration = ""
    var riskLevel: RiskLevel = .safe
    var didStopEarly = false

    var finishState: FinishType {
        if didStopEarly {
            return .stopEarly
        }
        switch riskLevel {
        case .safe, .moderate:
            return .finish
        case .high, .emergency:
            return .finishWithAlert
        }
    }

    @MainActor
    func fetchCurrentRunner(eventId: UUID) async -> Runner? {
        if SupabaseManager.client.auth.currentUser == nil {
            do {
                try await SupabaseManager.client.auth.signInAnonymously()
            } catch {
                print("anon sign-in failed: \(error)")
                return nil
            }
        }

        guard let uid = SupabaseManager.client.auth.currentUser?.id else {
            print("User ID tidak tersedia")
            return nil
        }

        do {
            let runners: [Runner] = try await SupabaseManager.client
                .from("runners")
                .select()
                .eq("registered_by", value: uid)
                .eq("event_id", value: eventId)
                .limit(1)
                .execute()
                .value
            return runners.first
        } catch {
            print("Gagal mengambil runner: \(error)")
            return nil
        }
    }

    @MainActor
    func fetchFinishData(runner: Runner, elapsedSeconds: Int) async {
        finishDuration = Self.formatDuration(seconds: elapsedSeconds)
        
//        didStopEarly = await hasEmergencyRecord(runnerId: runner.id)

        do {
            let calculations: [RiskCalculation] = try await SupabaseManager.client
                .from("risk_calculations")
                .select()
                .eq("runner_id", value: runner.id)
                .execute()
                .value
            riskLevel = Self.averageRiskLevel(from: calculations)
        } catch {
            print("Gagal mengambil data risk_calculations: \(error)")
        }
    }
    
//    private func hasEmergencyRecord(runnerId: UUID) async -> Bool {
//        do {
//            let requests: [HelpRequest] = try await SupabaseManager.client
//                .from("help_requests")
//                .select()
//                .eq("runner_id", value: runnerId)
//                .limit(1)
//                .execute()
//                .value
//            return !requests.isEmpty
//        } catch {
//            print("Gagal cek help_requests: \(error)")
//            return false
//        }
//    }

    static func averageRiskLevel(from calculations: [RiskCalculation]) -> RiskLevel {
        let scores = calculations.map { Double($0.totalScore) }
        guard !scores.isEmpty else { return .safe }
        let avg = scores.reduce(0, +) / Double(scores.count)
        return RiskLevel(totalScore: avg)
    }

    static func formatDuration(seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        let s = seconds % 60
        return String(format: "%d:%02d:%02d", h, m, s)
    }
}

extension RiskLevel {
    init(totalScore: Double) {
        switch totalScore {
        case ..<5:  self = .safe
        case ..<15: self = .moderate
        case ..<25: self = .high
        default:    self = .emergency
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
                avgZone: riskLevel.label,
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
                avgZone: riskLevel.label,
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
                avgZone: riskLevel.label,
                statBackground: .inputBgcolor,
                message: "Good call stopping. Rest, hydrate, see medical if needed.",
                messageColor: .red, buttonTint: .red
            )
        }
    }
}
