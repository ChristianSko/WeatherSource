import Testing
@testable import WeatherSource

struct WeatherServiceFactoryTests {
    @Test
    func factoryCreatesCorrectServiceForProvider() {
        let appleService = WeatherServiceFactory.createService(for: .apple)
        let pirateService = WeatherServiceFactory.createService(for: .pirate)
        
        #expect(appleService is AppleWeatherService)
        #expect(pirateService is PirateWeatherService)
    }
    
    @Test
    func createdServicesUseCorrectProvider() {
        let appleService = WeatherServiceFactory.createService(for: .apple)
        let pirateService = WeatherServiceFactory.createService(for: .pirate)
        
        #expect(appleService.provider == .apple)
        #expect(pirateService.provider == .pirate)
    }
} 