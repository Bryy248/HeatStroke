//
//  RunningViewModel.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 07/07/26.
//

import SwiftUI
import Observation
import Supabase
import Combine

@Observable
final class RunningViewModel {
    
    // Running State
    enum RunningState {
        case ready
        case countdown
        case running
        case emergency
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
                return "Danger"
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
    var state: RunningState = .ready
    var condition: RunningCondition = .safe
    
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
    
    //for slow down
    var showSlowDown: Bool = false
    private var slowDownTask: Task<Void, Never>?
    
    //placeholder angka -> ubah biar bisa connect
    var heartRate = 0
    var bodyTemperature = 34.8
    var ambientTemperature = 31.0
    var humidity = 78.0
    
    //heart rate integration
    private let heartRateManager = HeartRateManager()
    private var cancellables = Set<AnyCancellable>()
    private var avgHRSendTimer: Task<Void, Never>?
    
    // wrist/core temperature
    private let wristTemperatureManager = WristTemperatureManager()
    private var coreTempSendTimer: Task<Void, Never>?
    private var latestAmbientTemperature: Double = 31.0 //fallback untuk ambient temperature
    
    // evironment data
    private let environmentDataManager = EnvironmentDataManager()
    
    //location user
    private let locationManager = LocationManager()
    
    //runner
    private var currentRunner: Runner?
    
    private var riskCalculationTimer: Task<Void, Never>?
    
    // MARK: function for ready animation
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
    
    
    // MARK: timer section
    var elapsedSeconds: Int = 0
    private var timerTask: Task<Void, Never>?
    private var startDate: Date?
    
    var formattedTimer: String {
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func startTimer(runner: Runner) {
        let now = Date()
        startDate = now
        elapsedSeconds = 0
        
        timerTask?.cancel() //cancel timer yang mungkin masih jalan
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard let startDate else { return }
                elapsedSeconds = Int(Date().timeIntervalSince(startDate))
            }
        }
        
        Task {
            await saveStartTime(runner: runner, startTime: now)
        }
    }
    
    func pauseTimer() {
        timerTask?.cancel()
        isPaused = true
    }
    
    func resumeTimer() {
        guard let pausedElapsed = elapsedSeconds as Int?, let startDate else { return }
        // geser startDate mundur sesuai elapsed yang udah kepakai, biar lanjut bukan reset
        self.startDate = Date().addingTimeInterval(-Double(pausedElapsed))
        
        timerTask?.cancel()
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard let currentStart = self.startDate else { return }
                elapsedSeconds = Int(Date().timeIntervalSince(currentStart))
            }
        }
        isPaused = false
    }
    
    func stopTimer() {
        guard let runner = currentRunner else { return }
        idleReminderTask?.cancel()
        timerTask?.cancel()
        let finishTime = Date()
        isFinished = true
        stopMonitoring()
        Task {
            await saveFinishTime(runner: runner, finishTime: finishTime)
        }
    }
    
    //function untuk masukin data timer ke database
    @MainActor
    private func saveStartTime(runner: Runner, startTime: Date) async {
        do {
            try await SupabaseManager.client
                .from("runners")
                .update(["start_time": ISO8601DateFormatter().string(from: startTime)])
                .eq("id", value: runner.id)
                .execute()
        } catch {
            print(error)
        }
    }
    
    @MainActor
    private func saveFinishTime(runner: Runner, finishTime: Date) async {
        do {
            try await SupabaseManager.client
                .from("runners")
                .update(["finish_time": ISO8601DateFormatter().string(from: finishTime)])
                .eq("id", value: runner.id)
                .execute()
        } catch {
            print(error)
        }
    }
    
    // MARK: function for monitoring
    func startMonitoring(runner: Runner) {
        currentRunner = runner
        
        // Mulai semua manager
        heartRateManager.start()
        environmentDataManager.start()
        wristTemperatureManager.authorize { [weak self] success in
            if success { self?.wristTemperatureManager.fetchLatest() }
        }
        
        // Observasi tiap manager, cuma buat update UI real-time (BUKAN buat insert database)
        heartRateManager.$value
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.heartRate = $0 }
            .store(in: &cancellables)
        
        wristTemperatureManager.$temperature
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] skinTemp in
                guard let self else { return }
                self.bodyTemperature = HeatStrokeRiskCalculator.estimatedCoreTemperature(
                    skinTemperature: skinTemp,
                    ambientTemperature: self.ambientTemperature
                )
            }
            .store(in: &cancellables)
        
        environmentDataManager.$averageTemperature
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] in self?.ambientTemperature = $0 }
            .store(in: &cancellables)
        
        environmentDataManager.$averageHumidity
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] in self?.humidity = $0 }
            .store(in: &cancellables)
        
        // Refresh wrist temp berkala (one-shot query, bukan live stream)
        Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(30))
                wristTemperatureManager.fetchLatest()
            }
        }
        
        // Timer TERPUSAT buat hitung & insert SATU row ke risk_calculations
        riskCalculationTimer?.cancel()
        riskCalculationTimer = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(30))
                await performRiskCalculation()
            }
        }
    }
    
    func stopMonitoring() {
        heartRateManager.stop()
        environmentDataManager.stop()
        riskCalculationTimer?.cancel()
        cancellables.removeAll()
    }
    
    // MARK: risk calculation dari suhu, hum, heart rate, dan wrist temp
    
    private var previousCondition: RunningCondition = .safe
    
    @MainActor
    private func performRiskCalculation() async {
        guard let runner = currentRunner else { return }
        guard let age = runner.age else { return }
        
        guard heartRateManager.value > 0 else { return }
        
        let avgHR = Double(heartRateManager.averageHeartRate ?? heartRateManager.value)
        
        let heatIndexValue = HeatStrokeRiskCalculator.heatIndex(
            temperature: ambientTemperature,
            humidity: humidity
        )
        
        let riskLevel = HeatStrokeRiskCalculator.overallRisk(
            heartRateBPM: avgHR,
            age: age,
            coreTemperatureC: bodyTemperature,
            heatIndexC: heatIndexValue
        )
        
        let percentHRmax = HeatStrokeRiskCalculator.percentOfMaxHeartRate(bpm: avgHR, age: age)
        let hrScore = HeatStrokeRiskCalculator.heartRateScore(percentHRmax: percentHRmax)
        let coreTempScore = HeatStrokeRiskCalculator.coreTemperatureScore(celsius: bodyTemperature)
        let heatIndexScoreValue = HeatStrokeRiskCalculator.heatIndexScore(heatIndexValue)
        let total = hrScore + coreTempScore + heatIndexScoreValue
        
        let newCondition = mapToRunningCondition(riskLevel)
            
            // Cuma trigger slow down kalau baru PERTAMA KALI masuk emergency dari kondisi lain
            if newCondition == .emergency && previousCondition != .emergency {
                triggerSlowDownIfNeeded()
            }
            
            previousCondition = newCondition
            self.condition = newCondition
        
        let calculation = RiskCalculation(
            id: UUID(),
            runnerId: runner.id,
            sensorReadingId: nil,
            heartRate: avgHR,
            bodyTemperatureC: bodyTemperature,
            heatIndexC: heatIndexValue,
            heartRateScore: hrScore,
            bodyTemperatureScore: coreTempScore,
            heatIndexScore: heatIndexScoreValue,
            totalScore: total,
            riskLevel: riskLevel.label.lowercased(),
            calculatedAt: Date()
        )
        
        do {
            try await SupabaseManager.client
                .from("risk_calculations")
                .insert(calculation)
                .execute()
            print("Risk calculation tersimpan: \(riskLevel.label)")
        } catch {
            print(error)
        }
    }
    
    //retuen run condition
    private func mapToRunningCondition(_ level: RiskLevel) -> RunningCondition {
        switch level {
        case .safe: return .safe
        case .moderate: return .moderate
        case .high: return .high
        case .emergency: return .emergency
        }
    }
    
    
    // MARK: function for countdown start running
    func startCountdown(runner: Runner) async { //async -> timer tanpa freeze
        
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
        startTimer(runner: runner)
        startMonitoring(runner: runner)
    }
    
    // MARK: function for emergency
    private var activeHelpRequestId: UUID?
    
    //status pending (call emergency)
    func callEmergency() {
        guard let runner = currentRunner else { return }
        
        idleReminderTask?.cancel()
        locationManager.start()
        state = .emergency
        
        Task {
            await createHelpRequest(runner: runner)
        }
    }
    
    @MainActor
    private func createHelpRequest(runner: Runner) async {
        let newId = UUID()
        activeHelpRequestId = newId
        
        let coordinate = locationManager.currentCoordinate
        
        let request = HelpRequest(
            id: newId,
            runnerId: runner.id,
            eventId: runner.eventId,
            requestedAt: Date(),
            latitude: coordinate?.latitude,
            longitude: coordinate?.longitude,
            status: "pending",
            riskLevelAtRequest: condition.title.lowercased(),
            marshalId: nil,
            respondedAt: nil
        )
        
        do {
            try await SupabaseManager.client
                .from("help_requests")
                .insert(request)
                .execute()
        } catch {
            print(error)
        }
    }
    
    //status resolved for emergency
    func resolveEmergency() {
        state = .running
        
        Task {
            await resolveHelpRequest()
        }
    }
    
    @MainActor
    private func resolveHelpRequest() async {
        guard let requestId = activeHelpRequestId else { return }
        
        do {
            try await SupabaseManager.client
                .from("help_requests")
                .update([
                    "status": "resolved",
                    "responded_at": ISO8601DateFormatter().string(from: Date())
                ])
                .eq("id", value: requestId)
                .execute()
            activeHelpRequestId = nil
        } catch {
            print(error)
        }
    }
    
    // MARK: function for slow down
    
    private var idleReminderTask: Task<Void, Never>?
    
    func triggerSlowDownIfNeeded() {
        guard condition == .emergency, firstTimeDangereous, !showSlowDown else { return }
        showSlowDown = true
        
        slowDownTask?.cancel()
        slowDownTask = Task {
            try? await Task.sleep(for: .seconds(10))
            guard !Task.isCancelled else { return }
            showSlowDown = false
            scheduleIdleReminder()
        }
    }
    
    func dismissSlowDown() {
        slowDownTask?.cancel()
        showSlowDown = false
        scheduleIdleReminder()
    }
    
    // function untuk mengatur supaya slow down muncul tiap 5 menit jika diabaikan
    private func scheduleIdleReminder() {
        idleReminderTask?.cancel()
        idleReminderTask = Task {
            try? await Task.sleep(for: .seconds(300))
            guard !Task.isCancelled else { return }
            triggerSlowDownIfNeeded()
        }
    }
    
    func cancelIdleReminder() {
        idleReminderTask?.cancel()
    }
}
