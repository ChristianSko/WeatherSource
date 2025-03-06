import Testing
@testable import WeatherSource

struct ResilientWeatherServiceTests {
    class FailingWeatherService: WeatherServiceProtocol {
        let provider: WeatherProvider
        let shouldFail: Bool
        var fetchCount = 0
        
        init(provider: WeatherProvider, shouldFail: Bool = true) {
            self.provider = provider
            self.shouldFail = shouldFail
        }
        
        func fetchWeather(for location: Location) async throws -> WeatherData {
            fetchCount += 1
            if shouldFail {
                throw WeatherError.providerError
            }
            return .mock(provider: provider)
        }
    }
    
    @Test
    func usesFallbackServiceWhenPrimaryFails() async throws {
        // Arrange
        let failingService = FailingWeatherService(provider: .apple, shouldFail: true)
        let backupService = FailingWeatherService(provider: .pirate, shouldFail: false)
        let resilientService = ResilientWeatherService(
            preferredProvider: .apple,
            services: [failingService, backupService]
        )
        
        // Act
        let location = Location(name: "Test City", latitude: 0, longitude: 0)
        let result = try await resilientService.fetchWeather(for: location)
        
        // Assert
        #expect(failingService.fetchCount == 1, "Primary service should be attempted")
        #expect(backupService.fetchCount == 1, "Backup service should be used")
        #expect(result.provider == .pirate, "Should get result from backup service")
    }
    
    @Test
    func throwsErrorWhenAllServicesFail() async throws {
        // Arrange
        let failingService1 = FailingWeatherService(provider: .apple, shouldFail: true)
        let failingService2 = FailingWeatherService(provider: .pirate, shouldFail: true)
        let resilientService = ResilientWeatherService(
            preferredProvider: .apple,
            services: [failingService1, failingService2]
        )
        
        // Act & Assert
        let location = Location(name: "Test City", latitude: 0, longitude: 0)
        do {
            let _ = try await resilientService.fetchWeather(for: location)
            #expect(false, "Should have thrown an error")
        } catch {
            #expect(error is WeatherError)
            #expect(failingService1.fetchCount == 1, "First service should be attempted")
            #expect(failingService2.fetchCount == 1, "Second service should be attempted")
        }
    }
    
    @Test
    func usesDefaultServicesWhenNotProvided() async throws {
        // Arrange
        let resilientService = ResilientWeatherService(preferredProvider: .apple)
        
        // Act
        let location = Location(name: "Test City", latitude: 0, longitude: 0)
        
        // Assert
        #expect(resilientService.provider == .apple, "Should use provided preferred provider")
        // Note: Can't test actual service calls here since we can't mock the factory easily
    }
}