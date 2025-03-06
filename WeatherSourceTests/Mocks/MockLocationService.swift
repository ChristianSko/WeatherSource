//
//  MockLocationService.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 6/3/25.
//

import CoreLocation
import Testing
@testable import WeatherSource

class MockLocationService: LocationService {
    override func geocode(cityName: String) async throws -> Location {
        if cityName == "Madrid" {
            return Location(name: "Madrid", latitude: 40.4168, longitude: -3.7038)
        }
        
        if cityName == "Rome" {
            return Location(name: "Rome", latitude: 41.9028, longitude: 12.4964)
        }
        
        if cityName == "New York" {
            return Location(name: "New York", latitude: 40.7128, longitude: -74.006)
        }
    
        throw LocationError.geocodingFailed
    }
}
