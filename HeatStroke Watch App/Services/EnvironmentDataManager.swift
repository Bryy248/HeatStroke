//
//  EnvironmentDataManager.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 03/07/26.
//

import Foundation
import Combine

class EnvironmentDataManager: ObservableObject {

    private struct Reading { let timestamp: Date; let temperature: Double; let humidity: Double }

    // MARK: - Konfigurasi ThingSpeak
    private let channelId  = "3422692"
    private let readApiKey = "B7DQ2IHWHRT716O0"
    private let pollInterval: TimeInterval = 30

    @Published var averageTemperature: Double? = nil
    @Published var averageHumidity: Double? = nil
    @Published var isConnected: Bool = false

    private var readings: [Reading] = []
    private let windowDuration: TimeInterval = 5 * 60
    private var timer: Timer?
    private var lastEntryId: Int?

    // MARK: - Public interface (tetap sama)
    func start() {
        stop()
        timer = Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { [weak self] _ in
            self?.fetchLatest()
        }
        fetchLatest()   // tarik sekali langsung di awal
    }

    func stop() {
        timer?.invalidate(); timer = nil
        readings.removeAll()
        lastEntryId = nil
        averageTemperature = nil
        averageHumidity = nil
        isConnected = false
    }

    // MARK: - Ambil entri terakhir dari ThingSpeak
    private func fetchLatest() {
        let urlStr = "https://api.thingspeak.com/channels/\(channelId)/feeds/last.json?api_key=\(readApiKey)"
        guard let url = URL(string: urlStr) else { return }

        var req = URLRequest(url: url)
        req.cachePolicy = .reloadIgnoringLocalCacheData
        req.timeoutInterval = 15

        URLSession.shared.dataTask(with: req) { [weak self] data, _, error in
            guard let self = self else { return }
            if let error = error {
                print("❌ ThingSpeak fetch: \(error.localizedDescription)")
                DispatchQueue.main.async { self.isConnected = false }
                return
            }
            guard let data = data else { return }
            self.handleResponse(data)
        }.resume()
    }

    private struct Feed: Decodable {
        let entry_id: Int?
        let field1: String?
        let field2: String?
    }

    private func handleResponse(_ data: Data) {
        guard let feed = try? JSONDecoder().decode(Feed.self, from: data),
              let entryId = feed.entry_id,
              let t = feed.field1.flatMap({ Double($0) }),
              let h = feed.field2.flatMap({ Double($0) }) else {
            print("❌ Gagal parse ThingSpeak / belum ada data")
            return
        }

        DispatchQueue.main.async {
            self.isConnected = true
            // Lewati kalau entry sama (ESP belum kirim data baru)
            guard entryId != self.lastEntryId else { return }
            self.lastEntryId = entryId

            self.readings.append(Reading(timestamp: Date(), temperature: t, humidity: h))
            let cutoff = Date().addingTimeInterval(-self.windowDuration)
            self.readings.removeAll { $0.timestamp < cutoff }

            guard !self.readings.isEmpty else { return }
            self.averageTemperature = self.readings.map { $0.temperature }.reduce(0, +) / Double(self.readings.count)
            self.averageHumidity    = self.readings.map { $0.humidity }.reduce(0, +) / Double(self.readings.count)
            print("🌡️ Env avg (\(self.readings.count)): T=\(String(format: "%.1f", self.averageTemperature ?? 0))°C, RH=\(String(format: "%.1f", self.averageHumidity ?? 0))%")
        }
    }
}
