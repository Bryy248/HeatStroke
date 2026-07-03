//
//  HeatStrokeViewModel.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 03/07/26.
//

import Foundation
import CoreLocation   
import Combine

class HeatStrokeViewModel: ObservableObject {

    @Published var isMonitoring: Bool = false
    @Published var currentHeartRate: Int = 0
    @Published var averageHeartRate: Int?
    @Published var averageAmbientTemp: Double?
    @Published var averageHumidity: Double?
    @Published var wristTemperature: Double?          // raw sensor, refresh ~1x/hari
    @Published var estimatedCoreTemperature: Double?   // hasil formula T_core
    @Published var heatIndex: Double?
    @Published var riskLevel: RiskLevel = .normal
    @Published var userAge: Int = 25
    @Published var currentCoordinate: CLLocationCoordinate2D?

    private let heartRateManager = HeartRateManager()
    private let environmentManager = EnvironmentDataManager()
    private let wristTemperatureManager = WristTemperatureManager()
    private let userProfileManager = UserProfileManager()
    private let locationManager = LocationManager()

    private var cancellables = Set<AnyCancellable>()

    init() {
        bindManagers()
    }

    func start() {
        environmentManager.start()
        
        HealthKitAuthManager.shared.requestAllAuthorizations { [weak self] success in
            guard success else { return }
            
            self?.userProfileManager.fetchAge()      
            self?.wristTemperatureManager.fetchLatest()
            
            DispatchQueue.main.async {
                self?.locationManager.start()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self?.heartRateManager.start()
                }
            }
        }
    }

    func stop() {
        heartRateManager.stop()
        environmentManager.stop()
        locationManager.stop()
    }

    private func bindManagers() {
        heartRateManager.$isMonitoring.receive(on: DispatchQueue.main).assign(to: &$isMonitoring)
        heartRateManager.$value.receive(on: DispatchQueue.main).assign(to: &$currentHeartRate)
        heartRateManager.$averageHeartRate.receive(on: DispatchQueue.main).assign(to: &$averageHeartRate)
        environmentManager.$averageTemperature.receive(on: DispatchQueue.main).assign(to: &$averageAmbientTemp)
        environmentManager.$averageHumidity.receive(on: DispatchQueue.main).assign(to: &$averageHumidity)
        wristTemperatureManager.$temperature.receive(on: DispatchQueue.main).assign(to: &$wristTemperature)
        userProfileManager.$age.receive(on: DispatchQueue.main).assign(to: &$userAge)
        locationManager.$currentCoordinate.receive(on: DispatchQueue.main).assign(to: &$currentCoordinate)

        // T_core dihitung ulang tiap kali wrist temp ATAU ambient avg berubah.
        // wrist temp cuma update ~1x/hari, ambient avg update tiap 30 detik —
        // jadi praktiknya T_core ikut ter-refresh tiap ada ambient avg baru,
        // pakai wrist temp terakhir yang tersedia.
        Publishers.CombineLatest($wristTemperature, $averageAmbientTemp)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] wristTemp, ambientTemp in
                guard let wristTemp = wristTemp, let ambientTemp = ambientTemp else {
                    self?.estimatedCoreTemperature = nil
                    return
                }
                self?.estimatedCoreTemperature = HeatStrokeRiskCalculator.estimatedCoreTemperature(
                    skinTemperature: wristTemp,
                    ambientTemperature: ambientTemp,
                    site: .hand
                )
            }
            .store(in: &cancellables)

        Publishers.CombineLatest4($averageHeartRate, $estimatedCoreTemperature, $averageAmbientTemp, $averageHumidity)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hr, coreTemp, ambientTemp, humidity in
                self?.recalculateRisk(hr: hr, coreTemp: coreTemp, ambientTemp: ambientTemp, humidity: humidity)
            }
            .store(in: &cancellables)
    }

    private func recalculateRisk(hr: Int?, coreTemp: Double?, ambientTemp: Double?, humidity: Double?) {
        guard let ambientTemp = ambientTemp, let humidity = humidity else { return }

        let hi = HeatStrokeRiskCalculator.heatIndex(temperature: ambientTemp, humidity: humidity)
        heatIndex = hi

        let effectiveHR = Double(hr ?? 70)
        let effectiveCoreTemp = coreTemp ?? 36.8

        let newRiskLevel = HeatStrokeRiskCalculator.overallRisk(
            heartRateBPM: effectiveHR,
            age: userAge,
            coreTemperatureC: effectiveCoreTemp,
            heatIndexC: hi
        )

        riskLevel = newRiskLevel
        locationManager.updateSamplingInterval(for: newRiskLevel)
    }
}
