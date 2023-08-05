//
//  SearchLocation.swift
//  WeatherReport
//
//  Created by Altug Parlak on 5.08.2023.
//

import Foundation

struct SearchResponse: Codable {
    let results: [SearchLocation]
}

struct SearchLocation: Codable {
    var name: String
    var lat: Double
    var lon: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case lat
        case lon
    }
}
