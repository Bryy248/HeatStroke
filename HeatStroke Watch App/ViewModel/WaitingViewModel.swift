//
//  WaitingViewModel.swift
//  HeatStroke
//
//  Created by Brian Juniarta Darmadi on 08/07/26.
//
import SwiftUI
import Combine
import Supabase

@Observable
class WaitingViewModel {
    
    
    var timeRemainingString = "Calculating..."
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var navigateToReady = false
    
    private var targetDate: Date?
    @ObservationIgnored private var cancellable: AnyCancellable?

//    init() {
//        self.targetDate = WaitingViewModel.getTargetDate()
//    }
    
    func start() {
        updateCountdown() // run once immediately, so no 1-second "Calculating..." flash
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateCountdown()
            }
        Task { await fetchTargetDate() }
    }

    func stop() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    
    
//    public static func getTargetDate() -> Date {
//        let calendar = Calendar.current
//        var components = DateComponents()
//        components.year = 2026
//        components.month = 7
//        components.day = 10
//        components.hour = 00
//        components.minute = 00
//        return calendar.date(from: components)!
//    }
    
    private let eventID = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    
    @MainActor
    private func fetchTargetDate() async {
        do {
            let event: Event = try await SupabaseManager.client
                .from("events")
                .select()
                .eq("id", value: eventID)
                .single()
                .execute()
                .value
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            if let start = event.startTime,
               let date = formatter.date(from: start) {
                   targetDate = date
               }

            
        } catch {
            print("Failed to fetch event: \(error)")
        }
        
    }
    
    
    private func updateCountdown() {
        let now = Date.now
        
        guard let targetDate else {
            timeRemainingString = "Calculating..."
            return
        }
        
        
        guard now < targetDate else {
            timeRemainingString = "Event Started!"
            navigateToReady = true
            return
        }
        
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: targetDate)
        
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        timeRemainingString = String(format: "%02d : %02d : %02d", days, hours, minutes)
    }
    
}
