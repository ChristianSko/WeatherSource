//
//  SavedLocation.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 3/3/25.
//

import CoreLocation
import SwiftData

@Model
final class SavedLocation {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    
    var latitude: Double
    var longitude: Double
    
    init(
        name: String,
        latitude: Double,
        longitude: Double
    ) {
        self.id = UUID()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension SavedLocation {
    /// Creates a mock SavedLocation instance for SwiftUI previews
    static func previewMock(
        name: String = "Barcelona",
        latitude: Double = 41.3851,
        longitude: Double = 2.1734
    ) -> SavedLocation {
        let location = SavedLocation(
            name: name,
            latitude: latitude,
            longitude: longitude
        )
        return location
    }
    
    /// Collection of sample locations
    static var samples: [SavedLocation] {
        [
            .previewMock(name: "Madrid", latitude: 40.4168, longitude: -3.7038),
            .previewMock(name: "London", latitude: 51.5074, longitude: -0.1278),
            .previewMock(name: "Oslo", latitude: 59.9139, longitude: 10.7522),
            .previewMock(name: "Paris", latitude: 48.8566, longitude: 2.3522),
            .previewMock(name: "Miami", latitude: 25.7617, longitude: -80.1918),
            .previewMock(name: "Berlin", latitude: 52.5200, longitude: 13.4050)
        ]
    }
}
