//
//  CityWeatherCell.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 5/3/25.
//

//
//  CityWeatherCell.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 5/3/25.
//

import SwiftUI

struct CityWeatherView: View {
    let weather: WeatherData?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                weatherInfoLeft
                Spacer()
                weatherInfoRight
            }
        }
        .padding(.vertical, Layout.verticalPadding)
        .contentShape(Rectangle())
    }
}

// MARK: - View Components
private extension CityWeatherView {
    var weatherInfoLeft: some View {
        VStack(alignment: .leading) {
            locationAndTime
            Spacer()
            conditionInfo
        }
    }
    
    var locationAndTime: some View {
        VStack(alignment: .leading) {
            if let weather = weather {
                
                Text(weather.location.capitalized)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(weather.timestamp.formatted(
                    Date.FormatStyle()
                        .hour()
                        .minute())
                )
                .font(.subheadline)
            }
        }
    }
    
    var conditionInfo: some View {
        Group {
            if let weather = weather {
                HStack {
                    Image(systemName: weatherIcon(for: weather.condition))
                        .font(.title)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(
                            weatherSymbolColors(for: weather.condition).primary,
                            weatherSymbolColors(for: weather.condition).secondary
                        )
                    
                    Text(weather.condition.rawValue.capitalized)
                }
                .font(.callout)
            }
        }
    }
    
    var weatherInfoRight: some View {
        Group {
            if let weather = weather {
                VStack(alignment: .trailing) {
                    humidityInfo(weather)
                    temperatureInfo(weather)
                    windInfo(weather)
                }
            }
        }
    }
}

// MARK: - Weather Info Components
private extension CityWeatherView {
    func humidityInfo(_ weather: WeatherData) -> some View {
        HStack {
            Image(systemName: SystemImageName.Details.humidity)
                .foregroundStyle(.cyan)
            
            Text(weather.humidityFormatted)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .font(.caption)
    }
    
    func temperatureInfo(_ weather: WeatherData) -> some View {
        Text(weather.temperatureFormatted)
            .contentTransition(.numericText())
            .font(.largeTitle)
            .fontWeight(.semibold)
    }
    
    func windInfo(_ weather: WeatherData) -> some View {
        HStack {
            Image(systemName: SystemImageName.Details.wind)
                .foregroundStyle(.black.opacity(Layout.symbolBlackOpacity))
            Text(weather.windSpeedFormatted)
                .foregroundColor(.secondary)
        }
        .font(.caption)
    }
}

// MARK: - Weather Utilities
private extension CityWeatherView {
    func weatherIcon(for condition: WeatherCondition) -> String {
        switch condition {
        case .clear:
            return SystemImageName.Weather.clear
        case .partlyCloudy:
            return SystemImageName.Weather.partlyCloudy
        case .cloudy:
            return SystemImageName.Weather.cloudy
        case .rain:
            return SystemImageName.Weather.rain
        case .snow:
            return SystemImageName.Weather.snow
        case .thunderstorm:
            return SystemImageName.Weather.thunderstorm
        case .windy:
            return SystemImageName.Weather.windy
        case .unknown:
            return SystemImageName.Weather.unknown
        }
    }
    
    func weatherSymbolColors(for condition: WeatherCondition) -> (primary: Color, secondary: Color) {
        switch condition {
        case .clear:
            return (.yellow, .orange)
        case .partlyCloudy:
            return (.gray, .yellow)
        case .cloudy:
            return (.gray, .white)
        case .rain:
            return (.blue, .cyan)
        case .snow:
            return (.blue, .white)
        case .thunderstorm:
            return (.purple, .yellow)
        case .windy:
            return (.blue, .black)
        case .unknown:
            return (.gray, .secondary)
        }
    }
}

// MARK: - Layout Constants
extension CityWeatherView {
    enum Layout {
        static let verticalPadding: CGFloat = 8
        static let symbolBlackOpacity: CGFloat = 0.5
    }
}

// MARK: - Preview
#Preview {
    List {
        CityWeatherView(weather: .mock())
    }
}
