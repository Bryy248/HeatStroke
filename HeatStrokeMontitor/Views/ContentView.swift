//
//  ContentView.swift
//  HeatStrokeMontitor
//
//  Created by Brian Chang on 02/07/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    
    let selectedRoute = dummyRoutes.first!
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: dummyRoutes.first!.points.first!.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.001,
                longitudeDelta: 0.001
            )
        )
    )
    
    var body: some View {
        Map(position: $position) {
            
            ForEach(dummyRunners) { runner in

                Annotation(
                    runner.bib,
                    coordinate: runner.coordinate
                ) {

                    Circle()
                        .fill(runner.heatRisk.color)
                        .frame(width: 24, height: 24)

                }

            }

            // MARK: - Marathon Route
            // menggambar jalur marathon dari kumpulan RoutePoint

            MapPolyline(
                coordinates: selectedRoute.points.map { $0.coordinate }
            )
            .stroke(
                .blue,
                lineWidth: 6
            )
        }
    }
}

#Preview {
    ContentView()
}
