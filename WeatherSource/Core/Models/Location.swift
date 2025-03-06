//
//  Location.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 2/3/25.
//

import CoreLocation

struct Location {
    let name: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
}
