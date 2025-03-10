//
//  WeatherSourceUITests.swift
//  WeatherSourceUITests
//
//  Created by Christian Skorobogatow on 2/3/25.
//

import XCTest

final class WeatherSourceUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testSearchfieldExists() {
        let expectedSearchfields = 1
        let actualSearchFields = app.searchFields.count
        
        XCTAssertEqual(
            expectedSearchfields,
            actualSearchFields,
            "Searchfield count mismatch: Expected \(expectedSearchfields), found \(actualSearchFields). One is required to search and add a city."
        )
    }
    func testListExistsAfterAddingLocation() {
        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("Madrid")
        app.keyboards.buttons["Search"].tap()
        
        let list = app.collectionViews.firstMatch
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == true"),
            object: list
        )
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertTrue(list.exists, "List should appear after adding a location")
    }
    func testChangeProviderButtonExists() {
        let changeProviderButton = app.buttons["Change provider"]
        XCTAssertTrue(changeProviderButton.exists, "Change provider button should exist to enable Toggling between services")
    }
    
    func testChangeToAppleWeatherButtonExists() {
        let changeProviderButton = app.buttons["Change provider"]
        changeProviderButton.tap()
        
        let appleWeatherButton = app.buttons["Apple Weather"]
        XCTAssertTrue(appleWeatherButton.exists, "Apple Weather button should exist to switch to Apple Weather provider")
    }
    
    func testChangeToPirateWeatherButtonExists() {
        let changeProviderButton = app.buttons["Change provider"]
        changeProviderButton.tap()
        
        let pirateWeatherButton = app.buttons["Pirate Weather"]
        XCTAssertTrue(pirateWeatherButton.exists, "Pirate Weather button should exist to switch to Pirate Weather provider")
    }
    
    func testMoreButtonExists() {
        let moreButton = app.buttons["More"]
        XCTAssertTrue(moreButton.exists, "More button should exist to offer additional options")
    }
    
    func testDeleteAllLocationsButtonExists() {
        let moreButton = app.buttons["More"]
        moreButton.tap()
        
        let deleteAllLocationsButton = app.buttons["Delete all"]
        XCTAssertTrue(deleteAllLocationsButton.exists, "Delete all button should exist to delete all locations")
        
    }
}
