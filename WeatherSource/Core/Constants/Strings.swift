//
//  Strings.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 6/3/25.
//

import Foundation

enum Strings {
    
    enum Titles {
        static let weather = "Weather"
        static let appleWeather = "Apple Weather"
        static let pirateWeather = "Pirate Weather"
    }
    
    enum Locations {
        static let noLocations = "No Locations"
        static let addLocationPrompt = "Add a location to start tracking weather"
        static let notInLocations = "' is not in your locations"
        static let alreadyExists = "' is already in your locations."
        static let searchOrAddPrompt = "Add or filter for a city"
        static let locationNotFound = "Could not find location '"
        static let checkAndTryAgain = "'. Please check the city name and try again."
        
        static func locationNotInList(_ locationName: String) -> String {
            return "'\(locationName)' is not in your locations"
        }
    }
    
    enum Actions {
        static let add = "Add"
        static let changeProvider = "Change provider"
        static let deleteAll = "Delete all"
        static let more = "More"
        
        static func addLocation(_ locationName: String) -> String {
            return "Add \(locationName)"
        }
    }
    
    enum Providers {
        static func usingProvider(_ providerName: String) -> String {
            return "Using \(providerName)"
        }
    }
    
    enum Errors {
        static let title = "Error"
        static let dismissButton = "OK"
        static let invalidCityName = "Please enter a valid city name."
        static let errorSaving = "An error occurred while saving the location."
    }
}
