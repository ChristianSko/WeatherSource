//
//  ResilientWeatherService.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 6/3/25.
//

import Foundation

class ResilientWeatherService: WeatherServiceProtocol {
    private let services: [WeatherServiceProtocol]
    let provider: WeatherProvider
    
    init(preferredProvider: WeatherProvider, services: [WeatherServiceProtocol]? = nil) {
        self.provider = preferredProvider
        self.services = services ?? [
            WeatherServiceFactory.createService(for: preferredProvider),
            WeatherServiceFactory.createService(for: preferredProvider == .apple ? .pirate : .apple)
        ]
    }
    
    func fetchWeather(for location: Location) async throws -> WeatherData {
        var lastError: Error?
        
        for service in services {
            do {
                return try await service.fetchWeather(for: location)
            } catch {
                lastError = error
                continue
            }
        }
        
        throw lastError ?? WeatherError.providerError
    }
}
