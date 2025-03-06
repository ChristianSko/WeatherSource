//
//  PirateWeatherResponse.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 6/3/25.
//

import Foundation

// MARK: - Response Models

struct PirateWeatherResponse: Decodable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let currently: CurrentWeather
    let hourly: HourlyForecast?
    let daily: DailyForecast?
}

// MARK: - Weather Models

struct CurrentWeather: Decodable {
    let time: TimeInterval
    let summary: String
    let icon: String
    let temperature: Double
    let apparentTemperature: Double
    let humidity: Double
    let windSpeed: Double
    let windGust: Double?
    let windBearing: Double?
    let uvIndex: Double?
    let visibility: Double?
    let pressure: Double?
}

struct HourlyForecast: Decodable {
    let summary: String?
    let icon: String?
    let data: [CurrentWeather]
}

struct DailyForecast: Decodable {
    let summary: String?
    let icon: String?
    let data: [DailyWeather]
}

struct DailyWeather: Decodable {
    let time: TimeInterval
    let summary: String?
    let icon: String?
    let sunriseTime: TimeInterval?
    let sunsetTime: TimeInterval?
    let temperatureHigh: Double?
    let temperatureLow: Double?
    let precipProbability: Double?
    let precipType: String?
}
