//
//  DummyRoute.swift
//  MapKitExplore
//
//  Created by Vannya Ade Gunawan on 02/07/26.
//

import Foundation
import MapKit

// Dummy Database
// anggap data ini berasal dari database panitia marathon

let dummyRoutes: [Route] = [

    Route(

        id: "GBK-5K",

        name: "GBK Fun Run 5K",

        points: [

            RoutePoint(
                coordinate: CLLocationCoordinate2D(
                    latitude: -6.2186,
                    longitude: 106.8025
                )
            ),

            RoutePoint(
                coordinate: CLLocationCoordinate2D(
                    latitude: -6.2175,
                    longitude: 106.8040
                )
            ),

            RoutePoint(
                coordinate: CLLocationCoordinate2D(
                    latitude: -6.2160,
                    longitude: 106.8065
                )
            ),

            RoutePoint(
                coordinate: CLLocationCoordinate2D(
                    latitude: -6.2145,
                    longitude: 106.8085
                )
            ),

            RoutePoint(
                coordinate: CLLocationCoordinate2D(
                    latitude: -6.2130,
                    longitude: 106.8105
                )
            )

        ]

    )

]
