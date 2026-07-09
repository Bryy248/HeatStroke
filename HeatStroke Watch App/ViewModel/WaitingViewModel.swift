//
//  WaitingViewModel.swift
//  HeatStroke
//
//  Created by Brian Juniarta Darmadi on 08/07/26.
//
import SwiftUI
import Combine

@Observable
class WaitingViewModel {
    
    
    var timeRemainingString = "Calculating..."
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var navigateToReady = false
    
    private let targetDate: Date
    @ObservationIgnored private var cancellable: AnyCancellable?

    init() {
        self.targetDate = WaitingViewModel.getTargetDate()
    }
    
    func start() {
        updateCountdown() // run once immediately, so no 1-second "Calculating..." flash
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateCountdown()
            }
    }

    func stop() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    
    
    public static func getTargetDate() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 10
        components.hour = 00
        components.minute = 00
        return calendar.date(from: components)!
    }
    
    private func updateCountdown() {
        let now = Date.now
        
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
