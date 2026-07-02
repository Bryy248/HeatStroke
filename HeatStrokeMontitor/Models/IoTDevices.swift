//
//  IoTDevices.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 02/07/26.
//

import Foundation
import MapKit

struct IoTDevice: Identifiable {

    // MARK: - Identity

    let id: String
    // contoh:
    // IOT-001
    // IOT-002

    // MARK: - Location

    let coordinate: CLLocationCoordinate2D
    // lokasi IoT dipasang
    // nanti dipakai buat Marker di MapKit

    // MARK: - Environment Data

    var humidity: Double?
    // kelembapan (%)

    var temperature: Double?
    // suhu lingkungan (°C)

}
