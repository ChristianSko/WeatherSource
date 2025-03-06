//
//  APIKeys.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 6/3/25.
//


import Foundation

enum APIKeys {
    static var pirateWeather: String {
        // Replace with your own API key from https://pirateweather.net
        // In production, this should be handled through a more secure mechanism
        guard let apiKey = Bundle.main.infoDictionary?["PIRATE_WEATHER_API_KEY"] as? String,
              !apiKey.isEmpty && apiKey != "YOUR_API_KEY_HERE" else {
            return ProcessInfo.processInfo.environment["PIRATE_WEATHER_API_KEY"] ?? "YOUR_API_KEY_HERE"
        }
        return apiKey
    }
}
