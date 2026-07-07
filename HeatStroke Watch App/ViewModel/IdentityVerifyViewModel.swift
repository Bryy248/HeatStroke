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

    // set registered_by = user ini, biar muncul di landing page
    @MainActor
    func claim(_ runner: Runner) async {
        guard let uid = SupabaseManager.client.auth.currentUser?.id else { return }
        do {
            try await SupabaseManager.client
                .from("runners")
                .update(["registered_by": uid])
                .eq("id", value: runner.id)
                .execute()
        }
        catch { print(error) }
    }

    private static func dateString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone(identifier: "UTC")
        return f.string(from: date)
    }
}
