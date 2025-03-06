# 🌦️ Weather Source

A clean, modular iOS weather application that allows users to search for locations and view current weather conditions using multiple weather service providers.

![App Demo](demo.gif)

## ✨ Features

- 🔍 **Search & Add Locations**: Search for cities and save them to track weather conditions
- 🔄 **Multiple Weather Providers**: Toggle between Apple Weather and Pirate Weather services
- 🧩 **Modular Architecture**: Service providers can be easily swapped or extended
- 🎨 **Adaptive UI**: Visual styling adapts based on the selected weather provider
- 🔒 **Input Validation**: Validation for location searches and coordinate handling
- 💾 **Persistent Storage**: SwiftData integration for saving location preferences
- ✅ **Comprehensive Testing**: Unit and UI tests for data reliability and feature verification via Swift Testing

## 🛠️ Technical Implementation

### Architecture

The app follows a clean architecture approach with:

- **MVVM Pattern**: Separation of UI (Views) from business logic (ViewModels)
- **Protocol-Based Services**: Weather and location services defined through protocols
- **Factory Pattern**: Easy creation and switching between weather service providers
- **SwiftData**: Modern persistence framework for storing location data

### Weather Providers

- **🍎 Apple Weather**: Uses WeatherKit for official Apple weather data
- **🏴‍☠️ Pirate Weather**: Uses the Pirate Weather API as an alternative source

## 📋 Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- WeatherKit entitlement (for Apple Weather provider)
- Pirate Weather API key (for Pirate Weather provider)

## 🚀 Getting Started

1. Clone the repository
2. Set up your `PIRATE_WEATHER_API_KEY` in the environment or add it to your `Info.plist`
3. Enable WeatherKit capability in your app target
4. Build and run!

## 🧪 Testing

The app includes:
- Unit tests for service implementations and data models
- UI tests for core user interactions

Run tests using `Cmd+U` or through the Test navigator in Xcode.

## 🧠 Design Decisions

- **Factory Pattern**: Makes it easy to add new weather service providers
- **Protocol-Based Services**: Ensures a consistent interface regardless of the provider
- **SwiftData**: Modern, type-safe persistence with minimal boilerplate code
- **Adaptive UI**: Different color schemes and icons based on the selected provider

## 📸 Screenshots

*[Screenshots will be added here]*

## 📝 License

This project is available under the MIT license.

## 🔗 Contact

Christian Skorobogatow - [GitHub Profile](https://github.com/christianskorobogatow) 