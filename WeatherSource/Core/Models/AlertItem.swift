//
//  AlertItem.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 5/3/25.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
    
    static func error(
        title: String = Strings.Errors.title,
        message: String,
        buttonTitle: String = Strings.Errors.dismissButton
    ) -> AlertItem {
        AlertItem(
            title: title,
            message: message,
            dismissButton: .default(Text(buttonTitle))
        )
    }
} 
