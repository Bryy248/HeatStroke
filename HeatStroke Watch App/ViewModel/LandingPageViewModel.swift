//
//  LandingPageViewModel.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 06/07/26.
//

import Foundation
import Observation
internal import PostgREST
import Supabase

@Observable
final class LandingPageViewModel {

    var events: [Event] = []
    var runners: [Runner] = []
    var isLoading = false

    var hasEvents: Bool {
        !events.isEmpty
    }

    // sementara di-comment dulu karena belum ada event date
//    var upcomingEvents: [Event] {
//        events
//            .filter { event in
//                guard let date = event.startDate else {
//                    return false
//                }
//                return date >= Date()
//            }
//            .sorted {
//                $0.startDate! < $1.startDate!
//            }
//    }

//    var pastEvents: [Event] {
//        events
//            .filter { event in
//                guard let date = event.startDate else {
//                    return false
//                }
//                return date < Date()
//            }
//            .sorted {
//                $0.startDate! > $1.startDate!
//            }
//    }
    
    var upcomingEvents: [Event] {
        events
    }

    var pastEvents: [Event] {
        []
    }

    @MainActor
    func fetchEvents() async {
        isLoading = true

        do {
            events = try await SupabaseManager.client
                .from("events")
                .select()
                .execute()
                .value

            runners = try await SupabaseManager.client
                .from("runners")
                .select()
                .execute()
                .value

        }
        catch {
            print(error)
            events = []
            runners = []
        }

        isLoading = false
    }

    @MainActor
    func delete(_ event: Event) async {
        do {
            try await SupabaseManager.client
                .from("events")
                .delete()
                .eq("id", value: event.id)
                .execute()

            events.removeAll {
                $0.id == event.id
            }

        }
        catch {
            print(error)
        }
    }
    
    func runner(for event: Event) -> Runner? {
        runners.first { $0.eventId == event.id }
    }
}
