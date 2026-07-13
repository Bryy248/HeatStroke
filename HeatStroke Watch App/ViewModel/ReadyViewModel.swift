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

    let runner: Runner
    private let env: EnvironmentDataManager
    
    init(env: EnvironmentDataManager, runner: Runner) {
        self.env = env
        self.runner = runner
        // forward: perubahan di manager otomatis mem-publish ulang lewat VM
        env.$isConnected.assign(to: &$isConnected)
        env.$averageHumidity.assign(to: &$avgHumidity)
        env.$averageTemperature.assign(to: &$avgTemperature)
    }

    var isDetected: Bool { isConnected && avgHumidity != nil }

    var humidity: Int { Int((avgHumidity ?? 0).rounded()) }
    var temperature: Int { Int((avgTemperature ?? 0).rounded()) }

    private let humidityTrimStartMin: CGFloat = 0.07
    private let humidityTrimEndFixed: CGFloat = 0.93
    private let temperatureTrimStartMin: CGFloat = 0.07
    private let temperatureTrimEndFixed: CGFloat = 0.92
    private let tempMax: CGFloat = 43
    
    var humidityTrimStart: CGFloat {
        let pct = min(max(CGFloat(humidity) / 100, 0), 1)
        return humidityTrimEndFixed - (humidityTrimEndFixed - humidityTrimStartMin) * pct
    }

    var temperatureTrimStart: CGFloat {
        let pct = min(max(CGFloat(temperature) / tempMax, 0), 1)
        return temperatureTrimEndFixed - (temperatureTrimEndFixed - temperatureTrimStartMin) * pct
    }
    
    func start() { env.start() }
    func stop()  { env.stop() }
    func startMeasurement() {
        goToRunning = true
    }
}
