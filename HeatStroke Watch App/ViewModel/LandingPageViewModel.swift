//
//  LandingPageViewModel.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 06/07/26.
//

import Foundation
import SwiftData
import Observation

@Observable
final class LandingPageViewModel {

    private let modelContext: ModelContext
    var events: [Events] = []

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchEvents()
    }

    var upcomingEvents: [Events] {
        events
            .filter { $0.date >= Date() }
            .sorted { $0.date < $1.date }
    }

    var pastEvents: [Events] {
        events
            .filter { $0.date < Date() }
            .sorted { $0.date > $1.date }
    }

    var hasEvents: Bool { !events.isEmpty }

    func fetchEvents() {
        let descriptor = FetchDescriptor<Events>(
            sortBy: [SortDescriptor(\.date, order: .forward)]
        )
        do {
            events = try modelContext.fetch(descriptor)
        } catch {
            print("Gagal fetch events: \(error)")
            events = []
        }
    }

    func delete(_ event: Events) {
        modelContext.delete(event)
        fetchEvents()
    }
}
