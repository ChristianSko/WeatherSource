//
//  LocationError.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 5/3/25.
//

import CoreLocation

enum LocationError: Error, Equatable {
    case geocodingFailed
    case invalidInput
    case duplicateLocation
}

class LocationService {
    private let geocoder = CLGeocoder()
    
    func geocode(cityName: String) async throws -> Location {
        guard !cityName.isEmpty else {
            throw LocationError.invalidInput
        }
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(cityName)
            
            guard
                let placemark = placemarks.first,
                let location = placemark.location,
                let name = placemark.locality ?? placemark.name else {
                throw LocationError.geocodingFailed
            }
            
            return Location(
                name: name,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        } catch {
            throw LocationError.geocodingFailed
        }
    }
}
