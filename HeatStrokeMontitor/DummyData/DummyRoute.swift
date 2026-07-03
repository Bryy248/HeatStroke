//
//  DummyRoute.swift
//  MapKitExplore
//
//  Created by Vannya Ade Gunawan on 02/07/26.
//

import Foundation
import MapKit

let parser = GPXParser()

let dummyRoutes: [Route] = {

    guard let url = Bundle.main.url(
        forResource: "Rute Marathon - BTN Jakim 2026",
        withExtension: "gpx"
    ) else {
        fatalError("GPX tidak ditemukan")
    }

    return [
        Route(
            id: "BTN-2026",
            name: "BTN Jakarta Marathon 2026",
            points: parser.parse(url: url)
        )
    ]
}()
