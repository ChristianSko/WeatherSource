//
//  WeatherProvider.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 5/3/25.
//

import Foundation

enum WeatherProvider: String, CaseIterable {
    case apple = "apple"
    case pirate = "pirate"
    
    var displayName: String {
        switch self {
        case .apple: 
            return Strings.Titles.appleWeather
        case .pirate:
            return Strings.Titles.pirateWeather
        }
    }
    
    var storageKey: String { rawValue }
    
    static func from(storageKey: String) -> WeatherProvider? {
        WeatherProvider(rawValue: storageKey)
    }
}

