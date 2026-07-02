//
//  RoutePoint.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 02/07/26.
//

import Foundation
import MapKit

struct RoutePoint: Identifiable {

    // MARK: - Identity

    let id = UUID()
    // supaya setiap titik memiliki identitas unik
    // berguna ketika digunakan di SwiftUI (ForEach)

    // MARK: - Coordinate

    let coordinate: CLLocationCoordinate2D
    // lokasi titik pada rute marathon

}
