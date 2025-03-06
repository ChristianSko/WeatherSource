//
//  FallbackWeatherServiceTests.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 6/3/25.
//

import SwiftUI
import Testing
@testable import WeatherSource

struct FallbackWeatherServiceTests {
    
    @Test
    func primaryServiceSucceedsNoFallbackNeeded() async throws {
        let primaryService = SuccessWeatherService(provider: .apple)
        let fallbackService = FailingWeatherService(provider: .pirate)
        let fallbackWeatherService = FallbackWeatherService(
            primaryService: primaryService,
            fallbackServices: [fallbackService]
        )
        
        let mockLocationService = MockLocationService()
        let location = try await mockLocationService.geocode(cityName: "Madrid")
        
        let weatherData = try await fallbackWeatherService.fetchWeather(for: location)
        
        #expect(weatherData.provider == .apple, "Provider should be the primary service's provider")
        #expect(weatherData.location == "Madrid", "Location should be preserved")
        #expect(primaryService.fetchCount == 1, "Primary service should be called once")
        #expect(fallbackService.fetchCount == 0, "Fallback service should not be called")
    }
    
    @Test
    func primaryServiceFailsFallbackSucceeds() async throws {
        let primaryService = FailingWeatherService(provider: .apple)
        let fallbackService = SuccessWeatherService(provider: .pirate)
        let fallbackWeatherService = FallbackWeatherService(
            primaryService: primaryService,
            fallbackServices: [fallbackService]
        )
        
        let mockLocationService = MockLocationService()
        let location = try await mockLocationService.geocode(cityName: "Madrid")
        
        let weatherData = try await fallbackWeatherService.fetchWeather(for: location)
        
        #expect(weatherData.provider == .pirate, "Provider should be the fallback service's provider")
        #expect(weatherData.location == "Madrid", "Location should be preserved")
        #expect(primaryService.fetchCount == 1, "Primary service should be called once")
        #expect(fallbackService.fetchCount == 1, "Fallback service should be called once")
    }
    
    @Test
    func multipleFallbacksWorkInOrder() async throws {
        let primaryService = FailingWeatherService(provider: .apple)
        let fallbackService1 = FailingWeatherService(provider: .pirate)
        let fallbackService2 = SuccessWeatherService(provider: .apple)
        let fallbackWeatherService = FallbackWeatherService(
            primaryService: primaryService,
            fallbackServices: [fallbackService1, fallbackService2]
        )
        
        let mockLocationService = MockLocationService()
        let location = try await mockLocationService.geocode(cityName: "Madrid")
        
        let weatherData = try await fallbackWeatherService.fetchWeather(for: location)
        
        #expect(weatherData.provider == .apple, "Provider should be from the successful fallback service")
        #expect(weatherData.location == "Madrid", "Location should be preserved")
        #expect(primaryService.fetchCount == 1, "Primary service should be called once")
        #expect(fallbackService1.fetchCount == 1, "First fallback service should be called once")
        #expect(fallbackService2.fetchCount == 1, "Second fallback service should be called once")
    }
    
    @Test
    func allServicesFail() async throws {
        let primaryService = FailingWeatherService(provider: .apple)
        let fallbackService1 = FailingWeatherService(provider: .pirate)
        let fallbackService2 = FailingWeatherService(provider: .apple)
        let fallbackWeatherService = FallbackWeatherService(
            primaryService: primaryService,
            fallbackServices: [fallbackService1, fallbackService2]
        )
        
        let mockLocationService = MockLocationService()
        let location = try await mockLocationService.geocode(cityName: "Madrid")
        
        do {
            let result  = try await fallbackWeatherService.fetchWeather(for: location)
            #expect(result == nil, "Should have thrown an error")
        } catch {
            #expect(error is WeatherError, "Error should be a WeatherError")
            #expect(primaryService.fetchCount == 1, "Primary service should be called once")
            #expect(fallbackService1.fetchCount == 1, "First fallback service should be called once")
            #expect(fallbackService2.fetchCount == 1, "Second fallback service should be called once")
        }
    }
    
    @Test
    func correctlyReportsProviderFromPrimaryService() {
        let primaryService = SuccessWeatherService(provider: .apple)
        let fallbackService = SuccessWeatherService(provider: .pirate)
        let fallbackWeatherService = FallbackWeatherService(
            primaryService: primaryService,
            fallbackServices: [fallbackService]
        )
        
        #expect(fallbackWeatherService.provider == .apple, "Provider should be from the primary service")
    }
}

// MARK: - Test Weather Services

private class SuccessWeatherService: WeatherServiceProtocol {
    let provider: WeatherProvider
    var fetchCount = 0
    
    init(provider: WeatherProvider) {
        self.provider = provider
    }
    
    func fetchWeather(for location: Location) async throws -> WeatherData {
        fetchCount += 1
        return WeatherData(
            temperature: 22.0,
            condition: .clear,
            humidity: 45,
            windSpeed: 10,
            location: location.name,
            provider: provider,
            timestamp: Date()
        )
    }
}

private class FailingWeatherService: WeatherServiceProtocol {
    let provider: WeatherProvider
    var fetchCount = 0
    
    init(provider: WeatherProvider) {
        self.provider = provider
    }
    
    func fetchWeather(for location: Location) async throws -> WeatherData {
        fetchCount += 1
        throw WeatherError.providerError
    }
}
