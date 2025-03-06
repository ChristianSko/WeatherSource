//
//  WeatherSourceTests.swift
//  WeatherSourceTests
//
//  Created by Christian Skorobogatow on 2/3/25.
//

import CoreLocation
import SwiftData
import Testing
@testable import WeatherSource


// MARK: - Weather Fetching Integration Tests

@MainActor
struct WeatherFetchingTests {
    private var container: ModelContainer!
    private var viewModel: ContentView.ContentViewModel!
    private var weatherService: MockWeatherService!
    
    private mutating func setupTest() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: SavedLocation.self, configurations: config)
        
        weatherService = MockWeatherService(provider: .apple)
        
        viewModel = ContentView.ContentViewModel(
            modelContext: container.mainContext,
            locationService: MockLocationService(),
            weatherService: weatherService
        )
    }
    
    @Test
    mutating func fetchWeatherForSavedLocation() async throws {
        try setupTest()
        
        await viewModel.saveLocationForCity("Madrid")
        assert(viewModel.savedLocations.count == 1)
        
        let weatherData = try await viewModel.fetchWeatherForLocation(viewModel.savedLocations[0])
        
        #expect(weatherData.location == "Madrid", "Weather data should be for Madrid")
        #expect(weatherData.provider == .apple, "Weather data should come from the Apple provider")
        #expect(weatherData.temperature != nil, "Temperature should be provided")
    }
    
    @Test
    mutating func weatherServiceSwitchesWithProvider() async throws {
        try setupTest()
        
        await viewModel.saveLocationForCity("Madrid")
        
        var weatherData = try await viewModel.fetchWeatherForLocation(viewModel.savedLocations[0])
        #expect(weatherData.provider == .apple, "Initial weather data should come from Apple provider")
        
        viewModel.switchProvider(to: .pirate)
        weatherData = try await viewModel.fetchWeatherForLocation(viewModel.savedLocations[0])
        #expect(weatherData.provider == .pirate, "After switching, weather data should come from Pirate provider")
    }
}
