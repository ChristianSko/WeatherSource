//
//  ContentView.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 2/3/25.
//

import SwiftData
import SwiftUI
import Observation

// MARK: - ContentView

struct ContentView: View {
    @State private var viewModel: ContentViewModel
    
    init(
        modelContext: ModelContext,
        locationService: LocationService
    ) {
        let viewModel = ContentViewModel(
            modelContext: modelContext,
            locationService: locationService
        )
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundGradient
                
                VStack {
                    if viewModel.savedLocations.isEmpty {
                        emptyStateView
                    } else {
                        locationsList
                        providerIndicator
                    }
                }
            }
            .overlay { emptyStateContentOverlay }
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: Strings.Locations.searchOrAddPrompt
            )
            .onSubmit(of: .search) {
                Task {
                    await viewModel.saveLocationInSearchField()
                }
            }
            .toolbar { toolbarContent }
            .navigationTitle(Strings.Titles.weather)
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: Text(alertItem.title),
                    message: Text(alertItem.message),
                    dismissButton: alertItem.dismissButton
                )
            }
        }
        .task {
            await viewModel.refreshAllWeatherData()
        }
    }
}

// MARK: - Main View Components

private extension ContentView {
    var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: backgroundColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    var emptyStateView: some View {
        ContentUnavailableView(
            Strings.Locations.noLocations,
            systemImage: SystemImageName.UI.noLocations,
            description: Text(Strings.Locations.addLocationPrompt)
        )
        .tint(viewModel.currentProvider == .pirate ? .brown : .blue)
    }
    
    var locationsList: some View {
        List {
            ForEach(viewModel.filteredLocations) { city in
                CityWeatherView(weather: viewModel.weatherData[city.name])
                    .onTapGesture {
                        Task {
                            do {
                                _ = try await viewModel.fetchWeatherForLocation(city)
                            } catch {
                                print("Error fetching weather: \(error)")
                            }
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.8))
            }
            .onDelete { indexSet in
                viewModel.deleteLocation(indexSet)
            }
        }
        .scrollContentBackground(.hidden)
    }
    
    var providerIndicator: some View {
        HStack {
            Text(viewModel.currentProvider == .apple ? "🍎" : "🏴‍☠️")
                .font(.title)
            Text(Strings.Providers.usingProvider(viewModel.currentProvider.displayName))
                .foregroundColor(.secondary)
        }
        .opacity(viewModel.searchText.isEmpty ? 1 : 0)
        .padding(.bottom, 8)
    }
}

// MARK: - Overlay Components

private extension ContentView {
    var emptyStateContentOverlay: some View {
        Group {
            if viewModel.isLoading {
                loadingOverlay
            } else if !viewModel.searchText.isEmpty && viewModel.filteredLocations.isEmpty {
                noResultsOverlay
            }
        }
    }
    
    var loadingOverlay: some View {
        ProgressView()
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.1))
    }
    
    var noResultsOverlay: some View {
        VStack(spacing: 12) {
            Text(Strings.Locations.locationNotInList(viewModel.searchText))
                .foregroundColor(.secondary)
            
            Button(action: {
                Task {
                    await viewModel.saveLocationInSearchField()
                }
            }) {
                Label(
                    Strings.Actions.addLocation(viewModel.searchText),
                    systemImage: SystemImageName.UI.add
                )
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}

// MARK: - Toolbar Components

private extension ContentView {
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            providerMenu
        }
        
        ToolbarItem(placement: .topBarLeading) {
            moreMenu
        }
    }
    
    var providerMenu: some View {
        Menu {
            ForEach(WeatherProvider.allCases, id: \.self) { provider in
                Button {
                    viewModel.switchProvider(to: provider)
                } label: {
                    HStack {
                        Text(provider.displayName)
                        if provider == viewModel.currentProvider {
                            Image(systemName: SystemImageName.UI.checkmark)
                        }
                    }
                }
                .disabled(provider == viewModel.currentProvider)
            }
        } label: {
            Label(
                Strings.Actions.changeProvider,
                systemImage: SystemImageName.UI.changeProvider
            )
        }
    }
    
    var moreMenu: some View {
        Menu {
            Button(
                Strings.Actions.deleteAll,
                systemImage: SystemImageName.UI.delete,
                role: .destructive
            ) {
                viewModel.deleteAllLocations()
            }
        } label: {
            Label(
                Strings.Actions.more,
                systemImage: SystemImageName.UI.more
            )
        }
    }
}

// MARK: - Helper Methods

private extension ContentView {
    func weatherIcon(for condition: WeatherCondition) -> String {
        switch condition {
        case .clear:
            return SystemImageName.Weather.clear
        case .partlyCloudy:
            return SystemImageName.Weather.partlyCloudy
        case .cloudy:
            return SystemImageName.Weather.cloudy
        case .rain:
            return SystemImageName.Weather.rain
        case .snow:
            return SystemImageName.Weather.snow
        case .thunderstorm:
            return SystemImageName.Weather.thunderstorm
        case .windy:
            return SystemImageName.Weather.windy
        case .unknown:
            return SystemImageName.Weather.unknown
        }
    }
    
    var backgroundColors: [Color] {
        switch viewModel.currentProvider {
        case .apple:
            return [
                Color.blue.opacity(0.3),
                Color.cyan.opacity(0.2)
            ]
        case .pirate:
            return [
                Color.red.opacity(0.2),
                Color.black.opacity(0.3)
            ]
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView(
        modelContext: ModelContext(try! ModelContainer(for: SavedLocation.self)),
        locationService: LocationService()
    )
}
