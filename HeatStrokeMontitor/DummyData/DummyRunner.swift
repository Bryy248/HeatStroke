//
//  DummyRunner.swift
//  MapKitExplore
//
//  Created by Vannya Ade Gunawan on 02/07/26.
//

import Foundation
import MapKit

// Dummy Database
// anggap data ini berasal dari Apple Watch / Firebase

let dummyRunners: [Runner] = [

    Runner(

        bib: "HM-001",

        heartRate: 98,

        bodyTemperature: 36.9,

        coordinate: CLLocationCoordinate2D(
            latitude: -6.2186,
            longitude: 106.8025
        ),

        heatRisk: .safe

    ),

    Runner(

        bib: "HM-002",

        heartRate: 132,

        bodyTemperature: 37.8,

        coordinate: CLLocationCoordinate2D(
            latitude: -6.2168,
            longitude: 106.8056
        ),

        heatRisk: .risk

    ),

    Runner(

        bib: "HM-003",

        heartRate: 168,

        bodyTemperature: 38.7,

        coordinate: CLLocationCoordinate2D(
            latitude: -6.2145,
            longitude: 106.8088
        ),

        heatRisk: .highRisk

    )

]
