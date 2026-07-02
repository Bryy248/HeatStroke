//
//  DummyIOT.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 02/07/26.
//

import Foundation
import MapKit

// Dummy Database
// anggap data ini berasal dari Firebase / IoT Server

let dummyIoTDevices: [IoTDevice] = [

    IoTDevice(

        id: "IOT-001",

        coordinate: CLLocationCoordinate2D(
            latitude: -6.2186,
            longitude: 106.8025
        ),

        humidity: 72,

        temperature: 33.5

    ),

    IoTDevice(

        id: "IOT-002",

        coordinate: CLLocationCoordinate2D(
            latitude: -6.2168,
            longitude: 106.8058
        ),

        humidity: 68,

        temperature: 34.1

    ),

    IoTDevice(

        id: "IOT-003",

        coordinate: CLLocationCoordinate2D(
            latitude: -6.2147,
            longitude: 106.8089
        ),

        humidity: 75,

        temperature: 32.8

    )

]
