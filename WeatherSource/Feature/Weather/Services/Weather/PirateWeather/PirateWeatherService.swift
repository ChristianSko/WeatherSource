//
//  PirateWeatherService.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 5/3/25.
//

import Foundation
import CoreLocation

// MARK: - PirateWeatherService

class PirateWeatherService: WeatherServiceProtocol {
    let provider: WeatherProvider = .pirate
    private let apiKey: String
    private let baseURL = "https://api.pirateweather.net/forecast"
    
    init(apiKey: String = APIKeys.pirateWeather) {
        self.apiKey = apiKey
    }
    
    func fetchWeather(for location: Location) async throws -> WeatherData {
        guard isValidCoordinates(latitude: location.latitude, longitude: location.longitude) else {
            throw WeatherError.invalidCoordinates
        }
        
        guard !apiKey.isEmpty else {
            throw WeatherError.providerError
        }
        
        do {
            let url = try buildRequestURL(for: location)
            let weatherResponse = try await fetchWeatherData(from: url)
            return mapResponseToWeatherData(weatherResponse, location: location)
        } catch {
            print("Error fetching Pirate Weather: \(error)")
            throw WeatherError.providerError
        }
    }
}

// MARK: - Private Helpers

private extension PirateWeatherService {
    func isValidCoordinates(latitude: Double, longitude: Double) -> Bool {
        return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180
    }
    
    func buildRequestURL(for location: Location) throws -> URL {
        let urlString = "\(baseURL)/\(apiKey)/\(location.latitude),\(location.longitude)?units=si"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidCoordinates
        }
        return url
    }
    
    func fetchWeatherData(from url: URL) async throws -> PirateWeatherResponse {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.networkError
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(PirateWeatherResponse.self, from: data)
    }
    
    func mapResponseToWeatherData(_ response: PirateWeatherResponse, location: Location) -> WeatherData {
        return WeatherData(
            temperature: response.currently.temperature,
            condition: mapPirateCondition(response.currently.icon),
            humidity: Int(response.currently.humidity * 100),
            windSpeed: response.currently.windSpeed,
            location: location.name,
            provider: .pirate,
            timestamp: Date(timeIntervalSince1970: response.currently.time)
        )
    }
    
    func mapPirateCondition(_ icon: String) -> WeatherCondition {
        switch icon {
        case "clear-day", "clear-night":
            return .clear
        case "partly-cloudy-day", "partly-cloudy-night":
            return .partlyCloudy
        case "cloudy":
            return .cloudy
        case "rain":
            return .rain
        case "snow", "sleet":
            return .snow
        case "thunderstorm":
            return .thunderstorm
        default:
            return .unknown
        }
    }
}
