//
//  Route.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 02/07/26.
//

import Foundation
import MapKit

struct Route: Identifiable{
    
    /// MARK: - Identity
    
    let id: String
    // contoh:
    // JM-42K
    // JM-21K
    // BALI-10K

    let name: String
    // nama route yang ditampilkan di aplikasi

    // MARK: - Route Data

    let points: [RoutePoint]
    // kumpulan titik yang membentuk jalur marathon

}
