
import SwiftUI
import Testing
@testable import WeatherSource

struct WeatherDataTests {
    @Test
    func weatherDataModelHasRequiredProperties() {
        let weatherData = WeatherData(
            temperature: 25.5,
            condition: .clear,
            humidity: 60,
            windSpeed: 10.2,
            location: "Madrid",
            provider: .apple,
            timestamp: Date()
        )
        
        #expect(weatherData.temperature == 25.5)
        #expect(weatherData.condition == .clear)
        #expect(weatherData.humidity == 60)
        #expect(weatherData.windSpeed == 10.2)
        #expect(weatherData.location == "Madrid")
        #expect(weatherData.provider == .apple)
        #expect(weatherData.timestamp != nil)
    }
}
