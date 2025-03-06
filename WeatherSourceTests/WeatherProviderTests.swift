import CoreLocation
import SwiftData
import Testing
@testable import WeatherSource

@MainActor
struct WeatherProviderTests {
    private func makeViewModel() -> ContentView.ContentViewModel {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for: SavedLocation.self,
            configurations: configuration
        )
        
        return ContentView.ContentViewModel(
            modelContext: container.mainContext,
            locationService: LocationService(),
            currentProvider: .apple
        )
    }
    
    @Test
    func appleIsDefaultWeatherProvider() {
        let viewModel = makeViewModel()
        #expect(viewModel.currentProvider == .apple, "Default provider should be Apple Weather")
    }
    
    @Test
    func canChangeWeatherProvider() {
        let viewModel = makeViewModel()
        
        viewModel.switchProvider(to: .pirate)
        #expect(viewModel.currentProvider == .pirate, "Provider should be switched to Pirate Weather")
    }
    
    @Test
    func canChangeWeatherProviderBackAndForth() {
        let viewModel = makeViewModel()
        
        viewModel.switchProvider(to: .pirate)
        #expect(viewModel.currentProvider == .pirate, "Provider should be switched to Pirate Weather")
        
        viewModel.switchProvider(to: .apple)
        #expect(viewModel.currentProvider == .apple, "Provider should be switched back to Apple Weather")
    }
} 