//
//  enum.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 5/3/25.
//

import Foundation

protocol WeatherServiceProtocol {
    var provider: WeatherProvider { get }
    func fetchWeather(for location: Location) async throws -> WeatherData
}

class WeatherServiceFactory {
    static func createService(
        for provider: WeatherProvider,
        withFallback: Bool = true
    ) -> WeatherServiceProtocol {
        let primaryService = createPrimaryService(for: provider)
        
        guard withFallback else {
            return primaryService
        }
        
        return FallbackWeatherService(
            primaryService: primaryService,
            fallbackServices: createFallbackServices(excluding: provider)
        )
    }
    
    private static func createPrimaryService(for provider: WeatherProvider) -> WeatherServiceProtocol {
        switch provider {
        case .apple:
            return AppleWeatherService()
        case .pirate:
            return PirateWeatherService()
        }
    }
    
    private static func createFallbackServices(excluding provider: WeatherProvider) -> [WeatherServiceProtocol] {
        WeatherProvider.allCases
            .filter { $0 != provider }
            .map { createService(for: $0, withFallback: false) }
    }
}

