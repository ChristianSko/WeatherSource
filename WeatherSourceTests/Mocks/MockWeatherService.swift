//
//  MockWeatherService.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 6/3/25.
//

import CoreLocation
import Testing
@testable import WeatherSource

class MockWeatherService: WeatherServiceProtocol {
    let provider: WeatherProvider
    
    init(provider: WeatherProvider) {
        self.provider = provider
    }
    
    func fetchWeather(for location: Location) async throws -> WeatherData {
        guard location.latitude >= -90 && location.latitude <= 90 &&
              location.longitude >= -180 && location.longitude <= 180 else {
            throw WeatherError.invalidCoordinates
        }
        
        return WeatherData(
            temperature: Double.random(in: 0...30),
            condition: [.clear, .cloudy, .rain].randomElement()!,
            humidity: Int.random(in: 30...90),
            windSpeed: Double.random(in: 0...30),
            location: location.name,
            provider: provider,
            timestamp: Date()
        )
    }
}
