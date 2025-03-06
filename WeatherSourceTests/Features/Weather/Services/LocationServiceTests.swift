import Testing
@testable import WeatherSource

struct LocationServiceTests {
    @Test
    func geocodingValidCityReturnsLocation() async throws {
        let locationService = LocationService()
        let cityName = "Madrid"
        
        let result = try await locationService.geocode(cityName: cityName)
        
        #expect(result.name == "Madrid")
    }
    
    @Test
    func geocodingInvalidCityNameReturnsError() async throws {
        let locationService = LocationService()
        let invalidCityName = "XYZ123NonExistentCity"
        
        do {
            let result = try await locationService.geocode(cityName: invalidCityName)
            #expect(result == nil)
        } catch {
            #expect(error is LocationError)
            if let locationError = error as? LocationError {
                #expect(locationError == .geocodingFailed)
            }
        }
    }
} 