//
//  LocationData.swift
//  WeatherReport
//
//  Created by Altug Parlak on 5.08.2023.
//

import Foundation

struct SearchResponse2: Codable {
    let current: LocationData
    let location: Location
}

struct LocationData: Codable {
    var temp: Double
    var windSpeed: Double
    var humidity: Int
    var windDir: String
    var condition: Condition

    enum CodingKeys: String, CodingKey {
        case temp = "temp_c"
        case windSpeed = "wind_kph"
        case humidity = "humidity"
        case windDir = "wind_dir"
        case condition
    }
}

struct Condition: Codable {
    var text: String
    var icon: String?
    
    enum CodingKeys: String, CodingKey {
        case text
        case icon
    }
}

struct Location: Codable {
    var region: String
    var country: String
    var name: String
    var localtime: String
    
    enum CodingKeys: String, CodingKey {
        case region
        case country
        case name
        case localtime
    }
}
