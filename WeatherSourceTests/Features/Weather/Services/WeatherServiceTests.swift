//
//  WeatherServiceTests.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 6/3/25.
//

import Testing
@testable import WeatherSource

struct WeatherServiceTests {
    @Test
    func fetchWeatherForValidLocation() async throws {
        let mockService = MockWeatherService(provider: .apple)
        let location = Location(name: "Madrid", latitude: 40.4168, longitude: -3.7038)
        
        let weatherData = try await mockService.fetchWeather(for: location)
        
        #expect(weatherData.location == "Madrid")
        #expect(weatherData.provider == .apple)
        #expect(weatherData.temperature >= -50 && weatherData.temperature <= 50)
        #expect(weatherData.humidity >= 0 && weatherData.humidity <= 100)
    }
    
    @Test
    func fetchWeatherUsesCorrectProvider() async throws {
        let appleService = MockWeatherService(provider: .apple)
        let pirateService = MockWeatherService(provider: .pirate)
        let location = Location(name: "Madrid", latitude: 40.4168, longitude: -3.7038)
        
        let appleWeather = try await appleService.fetchWeather(for: location)
        let pirateWeather = try await pirateService.fetchWeather(for: location)
        
        #expect(appleWeather.provider == .apple)
        #expect(pirateWeather.provider == .pirate)
    }
    
    @Test
    func fetchWeatherWithInvalidCoordinatesThrowsError() async throws {
        let service = MockWeatherService(provider: .apple)
        let invalidLocation = Location(name: "XYZ123NonExistentCity", latitude: 1000, longitude: 1000)
        
        do {
            let result = try await service.fetchWeather(for: invalidLocation)
            #expect(result == nil)
        } catch {
            #expect(error is WeatherError)
            if let weatherError = error as? WeatherError {
                #expect(weatherError == .invalidCoordinates)
            }
        }
    }
} 
