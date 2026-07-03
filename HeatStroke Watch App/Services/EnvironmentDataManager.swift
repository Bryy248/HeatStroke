//
//  EnvironmentDataManager.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 03/07/26.
//

import Foundation
import Combine

/// Ambient temperature & humidity. MASIH DUMMY sampai sumber IoT tersedia.
/// Ganti isi fetchLatestReading() nanti — interface publik gak perlu berubah.
class EnvironmentDataManager: ObservableObject {

    private struct Reading {
        let timestamp: Date
        let temperature: Double
        let humidity: Double
    }

    @Published var averageTemperature: Double? = nil
    @Published var averageHumidity: Double? = nil

    private var readings: [Reading] = []
    private var timer: Timer?
    private let samplingInterval: TimeInterval = 30
    private let windowDuration: TimeInterval = 5 * 60

    func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: samplingInterval, repeats: true) { [weak self] _ in
            self?.takeSample()
        }
        takeSample()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        readings.removeAll()
        averageTemperature = nil
        averageHumidity = nil
    }

    private func takeSample() {
        let reading = fetchLatestReading()
        readings.append(reading)

        let cutoff = Date().addingTimeInterval(-windowDuration)
        readings.removeAll { $0.timestamp < cutoff }

        recalculateAverages()
    }

    private func recalculateAverages() {
        guard !readings.isEmpty else { return }
        let avgTemp = readings.map { $0.temperature }.reduce(0, +) / Double(readings.count)
        let avgHum = readings.map { $0.humidity }.reduce(0, +) / Double(readings.count)

        DispatchQueue.main.async {
            self.averageTemperature = avgTemp
            self.averageHumidity = avgHum
        }
        print("🌡️ Env avg (\(readings.count) sample): T=\(String(format: "%.1f", avgTemp))°C, RH=\(String(format: "%.1f", avgHum))%")
    }

    // TODO: ganti dengan fetch dari IoT device / backend kalau sumbernya sudah ada
    private func fetchLatestReading() -> Reading {
        Reading(timestamp: Date(), temperature: Double.random(in: 29...34), humidity: Double.random(in: 50...70))
    }
}
