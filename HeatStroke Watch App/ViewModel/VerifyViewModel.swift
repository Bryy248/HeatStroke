//
//  VerifyViewModel.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 07/07/26.
//

import SwiftUI
import Observation
internal import PostgREST
import Supabase

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
        
        do {
            // cari event yang code-nya cocok
            let events: [Event] = try await SupabaseManager.client
                .from("events")
                .select()
                .eq("code", value: code)
                .execute()
                .value
            
            if let event = events.first {
                state = .found(event)
            }
            else {
                state = .notFound
            }
        }
        catch {
            print(error)
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
}
