//
//  GPXParser.swift
//  HeatStroke
//
//  Created by Vannya Ade Gunawan on 03/07/26.
//

import Foundation
import MapKit

final class GPXParser: NSObject {

    private var coordinates: [CLLocationCoordinate2D] = []

    func parse(url: URL) -> [RoutePoint] {

        coordinates.removeAll()

        let parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()

        return coordinates.map {
            RoutePoint(coordinate: $0)
        }
    }
}

extension GPXParser: XMLParserDelegate {

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {

        guard elementName == "trkpt",
              let lat = attributeDict["lat"],
              let lon = attributeDict["lon"],
              let latitude = Double(lat),
              let longitude = Double(lon)
        else { return }

        coordinates.append(
            CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            )
        )
    }
}
