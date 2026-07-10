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
    
    private func startDate(of event: Event) -> Date? {
        guard let startTime = event.startTime else { return nil }
        return Self.parseISO(startTime)
    }

    // Coba parse dengan fractional seconds dulu, lalu fallback tanpa fractional.
    private static func parseISO(_ string: String) -> Date? {
        isoWithFraction.date(from: string) ?? isoPlain.date(from: string)
    }

    private static let isoWithFraction: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    private static let isoPlain: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()
    
    var upcomingEvents: [Event] {
        events
            .filter { event in
                guard let date = startDate(of: event) else { return false }
                return date >= Date()
            }
            .sorted { startDate(of: $0)! < startDate(of: $1)! }
    }
    
    var pastEvents: [Event] {
        events
            .filter { event in
                guard let date = startDate(of: event) else { return false }
                return date < Date()
            }
            .sorted { startDate(of: $0)! > startDate(of: $1)! }
    }
    
    @MainActor
    func fetchEvents() async {
        isLoading = true
        defer { isLoading = false }
        
        if SupabaseManager.client.auth.currentUser == nil {
            do {
                try await SupabaseManager.client.auth.signInAnonymously()
            } catch {
                print("anon sign-in failed: \(error)")
                events = []; runners = []
                return
            }
        }
        
        guard let uid = SupabaseManager.client.auth.currentUser?.id else {
                events = []; runners = []
                return
            }
        
        do {
            // hanya runner yang sudah di-claim user ini
            runners = try await SupabaseManager.client
                .from("runners")
                .select()
                .eq("registered_by", value: uid)
                .execute()
                .value
            
            // event diturunkan dari runner tsb
            let eventIds = runners.map { $0.eventId }
            guard !eventIds.isEmpty else {
                events = []
                return
            }
            
            events = try await SupabaseManager.client
                .from("events")
                .select()
                .in("id", values: eventIds)
                .execute()
                .value
        }
        catch {
            print(error)
            events = []; runners = []
        }
    }
    
    @MainActor
    func remove(_ event: Event) async {
        guard let uid = SupabaseManager.client.auth.currentUser?.id else { return }
        do {
            try await SupabaseManager.client
                .from("runners")
                .update(["registered_by": nil as UUID?])
                .eq("registered_by", value: uid)
                .eq("event_id", value: event.id)
                .execute()
            
            events.removeAll { $0.id == event.id }
            runners.removeAll { $0.eventId == event.id }
        }
        catch { print(error) }
    }
    
    func runner(for event: Event) -> Runner? {
        runners.first { $0.eventId == event.id }
    }
}
