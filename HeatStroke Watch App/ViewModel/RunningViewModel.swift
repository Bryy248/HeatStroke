//
//  RunningViewModel.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 07/07/26.
//

import SwiftUI
import Observation

@Observable
final class RunningViewModel {
    
    // Running State
    enum RunningState {
        case ready
        case countdown
        case running
        //
    }
    
    // Running Condition
    enum RunningCondition {
        case safe
        case moderate
        case high
        case emergency
        
        var icon: String {
            switch self {
            case .safe:
                return "figure.walk"
                
            case .moderate:
                return "figure.run"
                
            case .high:
                return "exclamationmark.triangle.fill"
                
            case .emergency:
                return "hand.raised.fill"
            }
        }
        
        var title: String {
            switch self {
            case .safe:
                return "Safe"
                
            case .moderate:
                return "Moderate"
                
            case .high:
                return "High"
                
            case .emergency:
                return "Dangerous"
            }
        }
        
        var color: Color {
            switch self {
            case .safe:
                return .color1
                
            case .moderate:
                return .yellow
                
            case .high:
                return .orangeHigh
                
            case .emergency:
                return .red
            }
        }
        
        var fontcolor: Color {
            switch self {
            case .safe:
                return .white
                
            case .moderate:
                return .white
                
            case .high:
                return .suhuBgcolor
                
            case .emergency:
                return .xmarkBgcolor
            }
        }
    }
    
    //state for enum -> placeholder
    var state: RunningState = .running
    var condition: RunningCondition = .high

    //condition when state is Running
    var isPaused = false
    var isFinished = false
    var firstTimeDangereous = true
    
    //for the ready and countdonw
    var countdown = 3
    var progressReady: CGFloat = 0
    var progressCountdown: CGFloat = 1
    
    //make sure tab yang akan muncul duluan adalah tab 1
    var selectedTab = 1
    
    //placeholder angka -> ubah biar bisa connect
    var heartRate = 138
    var bodyTemperature = 37
    var ambientTemperature = 31
    var humidity = 78
    var timer = "00:10,24"
    
//function for ready animation
    func startReady() {

        progressReady = 0

        withAnimation(.linear(duration: 2)) {
            progressReady = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.progressReady = 0
            self.state = .countdown
        }
    }
    
    //function for countdown animation
    func startCountdown() async { //async -> timer tanpa freeze

                for number in stride(from: 3, through: 1, by: -1) { //loop dari 3 hingga 1
                    countdown = number
                    
                    try? await Task.sleep(for: .milliseconds(50))
                    
                    withAnimation(.linear(duration: 1)) {
                        progressCountdown = CGFloat(number - 1) / 3
                    }
                    
                    
                    try? await Task.sleep(for: .seconds(1))
                    //await -> tunggu operasi selesai, task sleep -> program menunggu 1s
                }
        self.state = .running
            }
}
