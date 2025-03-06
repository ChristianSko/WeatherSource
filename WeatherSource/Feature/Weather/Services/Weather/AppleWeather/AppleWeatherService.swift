//
//  AppleWeatherService.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 5/3/25.
//

import CoreLocation
import Foundation
import WeatherKit

// MARK: - AppleWeatherService

class AppleWeatherService: WeatherServiceProtocol {
    let provider: WeatherProvider = .apple
    private let weatherService = WeatherService.shared
    
    func fetchWeather(for location: Location) async throws -> WeatherData {
        guard isValidCoordinates(latitude: location.latitude, longitude: location.longitude) else {
            throw WeatherError.invalidCoordinates
        }
        
        do {
            let clLocation = CLLocation(
                latitude: location.latitude,
                longitude: location.longitude
            )
        
            let currentWeather = try await weatherService.weather(
                for: clLocation,
                including: .current
            )
            
            return WeatherData(
                temperature: currentWeather.temperature.value,
                condition: mapWeatherKitCondition(currentWeather.condition),
                humidity: Int(currentWeather.humidity * 100),
                windSpeed: currentWeather.wind.speed.value,
                location: location.name,
                provider: .apple,
                timestamp: Date()
            )
        } catch {
            throw WeatherError.providerError
        }
    }
}

// MARK: - Private Helpers

private extension AppleWeatherService {
    func isValidCoordinates(latitude: Double, longitude: Double) -> Bool {
        return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180
    }
    
    func mapWeatherKitCondition(_ weatherKitCondition: WeatherKit.WeatherCondition) -> WeatherCondition {
        switch weatherKitCondition {
        case .clear:
            return .clear
        case .mostlyClear, .partlyCloudy:
            return .partlyCloudy
        case .mostlyCloudy, .cloudy:
            return .cloudy
        case .drizzle, .rain, .heavyRain:
            return .rain
        case .snow, .flurries, .heavySnow, .sleet:
            return .snow
        case .thunderstorms:
            return .thunderstorm
        default:
            return .unknown
        }
    }
}
