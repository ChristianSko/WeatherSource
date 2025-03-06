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
        for provider: WeatherProvider
    ) -> WeatherServiceProtocol {
        switch provider {
        case .apple:
            return AppleWeatherService()
        case .pirate:
            return PirateWeatherService()
        }
    }
}
