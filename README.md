# 🌦️ Weather Source

A clean, modular iOS weather application that allows users to search for locations and view current weather conditions using multiple weather service providers.

## ✨ Features

- 🔍 **Search & Add Locations**: Search for cities and save them to track weather conditions
- 🔄 **Multiple Weather Providers**: Toggle between Apple Weather and Pirate Weather services
- 🛡️ **Automatic Fallback System**: If one weather provider fails, the app automatically tries alternative providers
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
- **Composite Pattern**: Fallback service implementation that chains multiple providers
- **SwiftData**: Modern persistence framework for storing location data

### Weather Providers

- **🍎 Apple Weather**: Uses WeatherKit for official Apple weather data
- **🏴‍☠️ Pirate Weather**: Uses the Pirate Weather API as an alternative source
- **🔄 Fallback System**: Automatically tries alternative providers if the primary one fails

## 📋 Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- Apple Developer account (for WeatherKit)
- Pirate Weather API key (for Pirate Weather provider)

## 🚀 Getting Started

### General Setup

1. Clone the repository
2. Open the project in Xcode 15.0+
3. Build and run on a device or simulator running iOS 17.0+

### Apple Weather Setup

1. Sign in to your Apple Developer account in Xcode
2. Enable WeatherKit capability in your app target:
   - Select your app target in Xcode
   - Go to the "Signing & Capabilities" tab
   - Click "+ Capability" and add "WeatherKit"
3. Complete WeatherKit activation in App Store Connect:
   - Log in to [App Store Connect](https://appstoreconnect.apple.com/)
   - Navigate to your app
   - Under "App Services", enable WeatherKit
   - Accept the WeatherKit terms and conditions

### Pirate Weather Setup

1. Get a Pirate Weather API key from [pirateweather.net](https://pirateweather.net/)
2. Add your API key to the project using one of these methods:
   - Set `PIRATE_WEATHER_API_KEY` in your environment variables
   - Add it to your `Info.plist` under the key `PirateWeatherAPIKey`
   - Create a Constants.swift file with your API key (make sure to add this to .gitignore)

## 🧪 Testing

The app includes:
- Unit tests for service implementations and data models
- Specific tests for the fallback mechanism between weather providers
- UI tests for core user interactions

Run tests using `Cmd+U` or through the Test navigator in Xcode.

## 🧠 Design Decisions

- **Factory Pattern**: Makes it easy to add new weather service providers
- **Protocol-Based Services**: Ensures a consistent interface regardless of the provider
- **Fallback System**: Improves reliability by automatically using alternative providers when needed
- **SwiftData**: Modern, type-safe persistence with minimal boilerplate code
- **Adaptive UI**: Different color schemes and icons based on the selected provider

## 📸 Example
![RocketSim_Recording_iPhone_16_Pro_6 3_2025-03-06_03 50 41](https://github.com/user-attachments/assets/5491fec4-0f06-4d31-a1e5-5e6542031ed2)

## 📝 License

This project is available under the MIT license.

## 🔗 Contact

Christian Skorobogatow - [GitHub Profile](https://github.com/ChristianSko)
