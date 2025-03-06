//
//  WeatherSourceApp.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 2/3/25.
//

import SwiftUI
import SwiftData

@main
struct WeatherSourceApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: SavedLocation.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                modelContext: container.mainContext,
                locationService: LocationService()
            )
        }
        .modelContainer(container)
    }
}

