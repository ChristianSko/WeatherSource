//
//  LocationStorageTests.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 6/3/25.
//

import SwiftData
import SwiftUI
import Testing
@testable import WeatherSource


@MainActor
struct LocationStorageTests {
    private var container: ModelContainer!
    private var viewModel: ContentView.ContentViewModel!
    
    
    private mutating func setupTest() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: SavedLocation.self, configurations: config)
        
        viewModel = ContentView.ContentViewModel(
            modelContext: container.mainContext,
            locationService: MockLocationService()
        )
    }
    
    @Test
    mutating func initialLocationCountIsEmpty() async throws {
        try setupTest()
        
        #expect(viewModel.savedLocations.count == 0, "Initial saved locations should be empty")
    }
    
    
    @Test
    mutating func saveValidLocation() async throws {
        try setupTest()
        
        await viewModel.saveLocationForCity("Madrid")
        
        #expect(viewModel.savedLocations.count == 1, "After saving one location, there should be one location")
    }
    
    @Test
    mutating func saveInvalidLocation() async throws {
        try setupTest()
        
        await viewModel.saveLocationForCity("XYZ123NonExistentCity")
        
        #expect(viewModel.savedLocations.count == 0, "Invalid locations should not be saved")
    }
    
    @Test
    mutating func saveDuplicateLocation() async throws {
        try setupTest()
        
        await viewModel.saveLocationForCity("Madrid")
        assert(viewModel.savedLocations.count == 1)
        
        await viewModel.saveLocationForCity("Madrid")
        
        #expect(viewModel.savedLocations.count == 1, "Duplicate location should not be added")
        #expect(viewModel.alertItem != nil, "Alert should be shown for duplicate location")
        #expect(viewModel.alertItem?.message == "'Madrid' is already in your locations.", "Alert should mention the duplicate location")
    }
    
    @Test
    mutating func deleteLocationAtIndex() async throws {
        try setupTest()
        
        await viewModel.saveLocationForCity("Madrid")
        assert(viewModel.savedLocations.count == 1)
        
        let indexSet = IndexSet([0])
        viewModel.deleteLocation(indexSet)
        
        #expect(viewModel.savedLocations.count == 0, "Location should be removed after deletion")
    }
    
    @Test
    mutating func deleteWithOutOfBoundsIndex() async throws {
        try setupTest()
        
        await viewModel.saveLocationForCity("Madrid")
        assert(viewModel.savedLocations.count == 1)
        
        let invalidIndexSet = IndexSet([5])
        viewModel.deleteLocation(invalidIndexSet)
        
        #expect(viewModel.savedLocations.count == 1, "Invalid index deletion should not remove any locations")
    }
    
    @Test
    mutating func deleteAllLocations() async throws {
        try setupTest()
        
        await viewModel.saveLocationForCity("Madrid")
        await viewModel.saveLocationForCity("Rome")
        await viewModel.saveLocationForCity("New York")
        
        assert(viewModel.savedLocations.count == 3)
        
        viewModel.deleteAllLocations()
        
        #expect(viewModel.savedLocations.count == 0, "All locations should be removed after deleteAll")
    }
}

// MARK: - Location Filtering Tests

@MainActor
struct LocationFilterTests {
    private var container: ModelContainer!
    private var viewModel: ContentView.ContentViewModel!
    
    private mutating func setupTest() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: SavedLocation.self, configurations: config)
        
        viewModel = ContentView.ContentViewModel(
            modelContext: container.mainContext,
            locationService: MockLocationService()
        )
    }
    
    @Test
    mutating func filterLocationsWithEmptySearchText() async throws {
        try setupTest()
        
        await viewModel.saveLocationForCity("Madrid")
        await viewModel.saveLocationForCity("Rome")
        
        viewModel.searchText = ""
        
        #expect(viewModel.filteredLocations.count == 2, "Empty search should show all locations")
    }
    
    @Test
    mutating func filterLocationsWithMatchingSearchText() async throws {
        try setupTest()
        
        await viewModel.saveLocationForCity("Madrid")
        await viewModel.saveLocationForCity("Rome")
        
        viewModel.searchText = "mad"
        
        #expect(viewModel.filteredLocations.count == 1, "Search should return only matching locations")
        #expect(viewModel.filteredLocations.first?.name == "Madrid", "The matching location should be Madrid")
    }
    
    @Test
    mutating func filterLocationsWithNonMatchingSearchText() async throws {
        try setupTest()
        
        await viewModel.saveLocationForCity("Madrid")
        await viewModel.saveLocationForCity("Rome")
        
        viewModel.searchText = "Berlin"
        
        #expect(viewModel.filteredLocations.isEmpty, "Non-matching search should return empty results")
    }
    
    @Test
    mutating func filterIsCaseInsensitive() async throws {
        try setupTest()
        
        await viewModel.saveLocationForCity("Madrid")
        
        viewModel.searchText = "mAd"
        
        #expect(viewModel.filteredLocations.count == 1, "Case-insensitive search should find matches regardless of case")
        #expect(viewModel.filteredLocations.first?.name == "Madrid", "The matching location should be Madrid")
    }
}

