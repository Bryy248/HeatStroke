//
//  ReadyViewModel.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 07/07/26.
//

import Foundation
import Combine

class ReadyViewModel: ObservableObject {
    // mirror dari manager
    @Published private(set) var isConnected: Bool = false
    @Published private(set) var avgHumidity: Double? = nil
    @Published private(set) var avgTemperature: Double? = nil
    @Published var goToRunning = false

    private let env: EnvironmentDataManager

    init(env: EnvironmentDataManager) {
        self.env = env
        // forward: perubahan di manager otomatis mem-publish ulang lewat VM
        env.$isConnected.assign(to: &$isConnected)
        env.$averageHumidity.assign(to: &$avgHumidity)
        env.$averageTemperature.assign(to: &$avgTemperature)
    }

    var isDetected: Bool { isConnected && avgHumidity != nil }

    var humidity: Int { Int((avgHumidity ?? 0).rounded()) }
    var temperature: Int { Int((avgTemperature ?? 0).rounded()) }

    private let trimStart: CGFloat = 0.06
    private let humidityTrimFull: CGFloat = 0.7305
    private let tempTrimFull: CGFloat = 0.752
    private let tempMax: CGFloat = 43
    private let tempStart: CGFloat = 0.07
    private let tempEnd: CGFloat = 0.92
    
    var humidityTrimEnd: CGFloat {
        let pct = CGFloat(humidity) / 100
        return trimStart + (humidityTrimFull - trimStart) * min(max(pct, 0), 1)
    }

    var temperatureTrimEnd: CGFloat {
        let progress = CGFloat(temperature) / tempMax
        return tempStart + (tempEnd - tempStart) * progress
    }
    
    func start() { env.start() }
    func stop()  { env.stop() }
    func startMeasurement() {
        goToRunning = true
    }
}
