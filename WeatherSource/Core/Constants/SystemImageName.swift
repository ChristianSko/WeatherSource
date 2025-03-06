//
//  SystemImageName.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 6/3/25.
//

import Foundation

enum SystemImageName {
    enum Weather {
        static let clear = "sun.max"
        static let partlyCloudy = "cloud.sun"
        static let cloudy = "cloud"
        static let rain = "cloud.rain"
        static let snow = "cloud.snow"
        static let thunderstorm = "cloud.bolt"
        static let windy = "wind"
        static let unknown = "questionmark"
    }
    
    enum UI {
        static let add = "plus.circle.fill"
        static let checkmark = "checkmark"
        static let delete = "trash"
        static let more = "ellipsis.circle"
        static let changeProvider = "arrow.triangle.branch"
        static let noLocations = "icloud.slash.fill"
    }
    
    enum Details {
        static let humidity = "humidity.fill"
        static let wind = "wind.snow"
    }
}

