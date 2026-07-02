//
//  LocationManager.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 02/07/26.
//

import Foundation
import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    // object GPS
    private let manager = CLLocationManager()

    // lokasi user sekarang
    @Published var userLocation: CLLocation?

    // semua titik yang pernah dilewati user
    @Published var route: [CLLocationCoordinate2D] = []

    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func startUpdating() {
        manager.startUpdatingLocation()
    }

    func stopUpdating() {
        manager.stopUpdatingLocation()
    }

    // dipanggil setiap GPS mendapatkan lokasi baru
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {

        guard let location = locations.last else {
            return
        }

        userLocation = location

        // simpan history lokasi
        route.append(location.coordinate)
    }

}
