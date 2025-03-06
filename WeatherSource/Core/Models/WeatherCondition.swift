//
//  WeatherCondition.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 5/3/25.
//

import Foundation

enum WeatherCondition: String, Codable, CaseIterable {
    case clear
    case partlyCloudy
    case cloudy
    case rain
    case snow
    case thunderstorm
    case windy
    case unknown
}

enum WeatherError: Error {
    case invalidCoordinates
    case networkError
    case parsingError
    case providerError
    case unsupportedProvider
}

extension WeatherData {
    /// Creates a mock WeatherData instance for SwiftUI previews
    static func mock(
        temperature: Double = 23.5,
        condition: WeatherCondition = .clear,
        humidity: Int = 45,
        windSpeed: Double = 12.3,
        location: String = "Barcelona",
        provider: WeatherProvider = .apple,
        timestamp: Date = Date()
    ) -> WeatherData {
        return WeatherData(
            temperature: temperature,
            condition: condition,
            humidity: humidity,
            windSpeed: windSpeed,
            location: location,
            provider: provider,
            timestamp: timestamp
        )
    }
    
    /// Collection of sample weather data for various conditions
    static var samples: [WeatherData] {
        [
            .mock(
                temperature: 28.5,
                condition: .clear,
                humidity: 30,
                location: "Madrid"
            ),
            .mock(
                temperature: 18.2,
                condition: .cloudy,
                humidity: 65,
                location: "London"
            ),
            .mock(
                temperature: 5.1,
                condition: .snow,
                humidity: 85,
                location: "Oslo"
            ),
            .mock(
                temperature: 22.7,
                condition: .rain,
                humidity: 75,
                location: "Paris"
            ),
            .mock(
                temperature: 31.0,
                condition: .thunderstorm,
                humidity: 80,
                location: "Miami"
            ),
            .mock(
                temperature: 15.3,
                condition: .partlyCloudy,
                humidity: 50,
                location: "Berlin"
            )
        ]
    }
}
