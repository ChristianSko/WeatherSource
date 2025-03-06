//
//  URL+Ext.swift
//  WeatherSource
//
//  Created by Christian Skorobogatow on 6/3/25.
//


import Foundation

extension URL {
    init(_ staticString: StaticString) {
        let string = String(describing: staticString)

        if let url = URL(string: string) {
            self = url
        } else {
            fatalError("Unable to create URL from string: \(staticString)")
        }
    }
}