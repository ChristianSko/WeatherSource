import Foundation

class FallbackWeatherService: WeatherServiceProtocol {
    private let primaryService: WeatherServiceProtocol
    private let fallbackServices: [WeatherServiceProtocol]
    
    var provider: WeatherProvider {
        primaryService.provider
    }
    
    init(
        primaryService: WeatherServiceProtocol,
        fallbackServices: [WeatherServiceProtocol]
    ) {
        self.primaryService = primaryService
        self.fallbackServices = fallbackServices
    }
    
    func fetchWeather(for location: Location) async throws -> WeatherData {
        // Try primary service first
        do {
            return try await primaryService.fetchWeather(for: location)
        } catch {
            // Try each fallback service until one succeeds
            for service in fallbackServices {
                if let weather = try? await service.fetchWeather(for: location) {
                    return weather
                }
            }
            
            // If all services fail, throw the original error
            throw error
        }
    }
}
