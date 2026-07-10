//
//  LocationManager.swift
//  HeatStroke Watch App
//
//  Created by Brian Chang on 03/07/26.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var currentCoordinate: CLLocationCoordinate2D?
    @Published var lastRecordedAt: Date?

    private let locationManager = CLLocationManager()
    private var samplingInterval: TimeInterval = 60   // default: Normal/Moderate/High
    private var lastRecordedTimestamp: Date?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.allowsBackgroundLocationUpdates = true
    }

    func start() {
        print("📍 LocationManager.start() dipanggil, status: \(locationManager.authorizationStatus.rawValue)")
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            print("❌ Location authorization ditolak/dibatasi.")
        }
    }

    func stop() {
        locationManager.stopUpdatingLocation()
        lastRecordedTimestamp = nil
        currentCoordinate = nil
        lastRecordedAt = nil
    }

    /// Dipanggil dari ViewModel tiap kali riskLevel berubah.
    func updateSamplingInterval(for riskLevel: RiskLevel) {
        let newInterval: TimeInterval = (riskLevel == .emergency) ? 0 : 60
        guard newInterval != samplingInterval else { return }
        samplingInterval = newInterval
        print("📍 Sampling GPS diubah: \(newInterval == 0 ? "near real-time" : "\(Int(newInterval))s sekali")")
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        print("Authorization berubah menjadi: \(manager.authorizationStatus.rawValue)")

        switch manager.authorizationStatus {

        case .authorizedWhenInUse:
            print("✅ When In Use")

            locationManager.startUpdatingLocation()

        case .authorizedAlways:
            print("✅ Always")

            locationManager.startUpdatingLocation()

        case .denied:
            print("❌ Denied")

        case .restricted:
            print("❌ Restricted")

        case .notDetermined:
            print("⏳ Belum ditentukan")

        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }

        let now = Date()
        if let lastTimestamp = lastRecordedTimestamp, now.timeIntervalSince(lastTimestamp) < samplingInterval {
            return   // masih dalam interval throttle, buang update ini
        }

        lastRecordedTimestamp = now
        DispatchQueue.main.async {
            self.currentCoordinate = latest.coordinate
            self.lastRecordedAt = now
        }
        print("📍 Lokasi direkam: \(latest.coordinate.latitude), \(latest.coordinate.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️ Location error: \(error.localizedDescription)")
    }
}
