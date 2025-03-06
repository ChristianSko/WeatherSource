//
//  ContentViewModel.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 5/3/25.
//

import SwiftData
import SwiftUI
import Observation

extension ContentView {
    // MARK: - ContentViewModel
    
    @MainActor
    @Observable
    final class ContentViewModel {
        // MARK: - Public Properties
        
        var searchText = ""
        var savedLocations: [SavedLocation] = []
        var currentProvider: WeatherProvider = .apple
        var weatherData: [String: WeatherData] = [:]
        var isLoading = false
        var error: Error?
        var alertItem: AlertItem?
        
        var filteredLocations: [SavedLocation] {
            if searchText.isEmpty {
                return savedLocations
            }
            return savedLocations.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        
        // MARK: - Private Properties
        
        private let modelContext: ModelContext
        private let locationService: LocationService
        private var weatherService: WeatherServiceProtocol
        
        // MARK: - Initialization
        
        init(
            modelContext: ModelContext,
            locationService: LocationService,
            weatherService: WeatherServiceProtocol? = nil,
            currentProvider: WeatherProvider = .apple
        ) {
            self.modelContext = modelContext
            self.locationService = locationService
            self.currentProvider = currentProvider
            self.weatherService = weatherService ?? WeatherServiceFactory.createService(for: currentProvider)
            
            fetchSavedLocations()
        }
        
        // MARK: - Provider Management
        
        func switchProvider(to provider: WeatherProvider) {
            currentProvider = provider
            weatherService = WeatherServiceFactory.createService(for: provider)
            
            Task {
                await refreshAllWeatherData()
            }
        }
    }
}

// MARK: - Location Management

extension ContentView.ContentViewModel {
    func getLocationForCity(_ city: String) async throws -> Location {
        try await locationService.geocode(cityName: city)
    }
    
    func saveLocationForCity(_ city: String) async {
        do {
            let location = try await getLocationForCity(city)
            
            // Check for duplicate location
            if isDuplicateLocation(location.name) {
                showDuplicateLocationAlert(location.name)
                return
            }
            
            saveToPersistentStore(location)
            await refreshAllWeatherData()
        } catch LocationError.geocodingFailed {
            alertItem = .error(
                message: Strings.Locations.invalidLocation(city)
            )
        } catch LocationError.invalidInput {
            alertItem = .error(
                message: Strings.Errors.invalidCityName
            )
        } catch {
            alertItem = .error(
                message: Strings.Errors.errorSaving
            )
        }
    }
    
    func saveLocationInSearchField() async {
        if !searchText.isEmpty {
            await saveLocationForCity(searchText)
            searchText = ""
        }
    }
    
    func deleteLocation(_ indexSet: IndexSet) {
        let validIndices = indexSet.filter { $0 < savedLocations.count }
        
        for item in validIndices {
            let object = savedLocations[item]
            modelContext.delete(object)
            
            removeCachedWeatherData(for: object.name)
        }
        
        refreshSavedLocations()
    }
    
    func deleteAllLocations() {
        do {
            try modelContext.delete(model: SavedLocation.self)
            try modelContext.save()
            fetchSavedLocations()
        } catch {
            print("Failed to delete locations: \(error)")
        }
    }
    
    private func isDuplicateLocation(_ locationName: String) -> Bool {
        return savedLocations.contains(where: { $0.name.lowercased() == locationName.lowercased() })
    }
    
    private func showDuplicateLocationAlert(_ locationName: String) {
        alertItem = .error(
            message: locationName + Strings.Locations.alreadyExists
        )
    }
    
    private func saveToPersistentStore(_ location: Location) {
        let savedLocation = SavedLocation(
            name: location.name,
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        modelContext.insert(savedLocation)
        try? modelContext.save()
        
        fetchSavedLocations()
    }
}

// MARK: - Weather Data Management

extension ContentView.ContentViewModel {
    func fetchWeatherForLocation(_ location: SavedLocation) async throws -> WeatherData {
        isLoading = true
        defer { isLoading = false }
        
        let locationObj = Location(
            name: location.name,
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        let data = try await weatherService.fetchWeather(for: locationObj)
        weatherData[location.name] = data
        return data
    }
    
    func fetchWeatherForAllLocations() async throws -> [WeatherData] {
        var results: [WeatherData] = []
        
        for location in savedLocations {
            let data = try await fetchWeatherForLocation(location)
            results.append(data)
        }
        
        return results
    }
    
    func refreshAllWeatherData() async {
        isLoading = true
        error = nil
        
        do {
            _ = try await fetchWeatherForAllLocations()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    private func removeCachedWeatherData(for location: String) {
        weatherData.removeValue(forKey: location)
    }
}

// MARK: - Persistence Helpers

extension ContentView.ContentViewModel {
    func fetchSavedLocations() {
        do {
            let descriptor = FetchDescriptor<SavedLocation>(sortBy: [SortDescriptor(\.name)])
            savedLocations = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch saved locations: \(error)")
            savedLocations = []
        }
    }
    
    private func refreshSavedLocations() {
        fetchSavedLocations()
    }
}
