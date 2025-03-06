//
//  WeatherData.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 6/3/25.
//

import Foundation

struct WeatherData {
    let temperature: Double
    let condition: WeatherCondition
    let humidity: Int
    let windSpeed: Double
    let location: String
    let provider: WeatherProvider
    let timestamp: Date
    
    var temperatureFormatted: String {
        return String(format: "%.1f°C", temperature)
    }
    
    var humidityFormatted: String {
        return "\(humidity)%"
    }
    
    var windSpeedFormatted: String {
        return String(format: "%.1f km/h", windSpeed)
    }
}
