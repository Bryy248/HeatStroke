//
//  VerifyViewModel.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 07/07/26.
//

import SwiftUI
import Observation

@Observable
final class VerifyViewModel {
    enum State {
        case loading
        case found(Event)
        case notFound
    }

    private(set) var state: State = .loading
    let code: String

    init(code: String) {
        self.code = code
    }

    @MainActor
    func verify() async {
        state = .loading

        // simulasi loading, hapus kalau udah pakai Supabase asli
        try? await Task.sleep(for: .milliseconds(400))

        // TODO: ganti blok ini dgn query asli ke Supabase
        // (mis. .from("events").eq("code", value: code))
        if let event = Self.mockEvents[code.uppercased()] {
            state = .found(event)
        }
        else {
            state = .notFound
        }
    }

    // helper display: startTime/location masih optional & belum diformat,
    // jadi sementara ditangani di sini
    func dateLocationText(for event: Event) -> String {
        let date = event.startTime ?? "Date TBA"
        let location = event.location ?? "-"
        return "\(date) • \(location)"
    }

    // data dummy pengganti backend
    private static let mockEvents: [String: Event] = [
        "BTN123": Event(
            id: UUID(),
            name: "BTN JAKIM 2027",
            location: "Jakarta, Indonesia",
            startTime: "Aug 12, 2027 05:00 WIB",
            endTime: nil,
            createdAt: nil
        )
    ]
}
