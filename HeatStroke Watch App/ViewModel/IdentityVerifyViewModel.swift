//
//  IdentityVerifyViewModel.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 07/07/26.
//

import Foundation
import Observation
internal import PostgREST
import Supabase

@Observable
final class IdentityVerifyViewModel {
    enum State {
        case loading
        case found(Runner)
        case notFound
    }

    private(set) var state: State = .loading

    let event: Event
    let bib: String
    let birthDate: Date

    init(event: Event, bib: String, birthDate: Date) {
        self.event = event
        self.bib = bib
        self.birthDate = birthDate
    }

    @MainActor
    func verify() async {
        state = .loading
        do {
            // cek DUA-DUANYA cocok, di-scope ke event ini
            let runners: [Runner] = try await SupabaseManager.client
                .from("runners")
                .select()
                .eq("event_id", value: event.id)
                .eq("bib_number", value: bib)
                .eq("birth_date", value: Self.dateString(birthDate))
                .execute()
                .value

            state = runners.first.map { .found($0) } ?? .notFound
        }
        catch {
            print(error)
            state = .notFound
        }
    }
    
//    enum DeviceIdentity {
//        static var currentDeviceId: UUID {
//            if let saved = UserDefaults.standard.string(forKey: "device_id"),
//               let uuid = UUID(uuidString: saved) {
//                return uuid
//            }
//            let newId = UUID()
//            UserDefaults.standard.set(newId.uuidString, forKey: "device_id")
//            return newId
//        }
//    }

    // set registered_by = user ini, biar muncul di landing page
    @MainActor
    func claim(_ runner: Runner) async {
//        let deviceId = DeviceIdentity.currentDeviceId
        guard let deviceId = SupabaseManager.client.auth.currentUser?.id else  {
            print("❌ no signed-in user to claim with")
                    return
        }
        do {
            try await SupabaseManager.client
                .from("runners")
                .update(["registered_by": deviceId.uuidString])
                .eq("id", value: runner.id)
                .execute()
        }
        catch {
            print("❌ Error claim runner: \(error)")
        }
    }

    private static func dateString(_ date: Date) -> String {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", c.year!, c.month!, c.day!)
    }
}
