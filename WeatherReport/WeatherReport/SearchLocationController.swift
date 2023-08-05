//
//  SearchLocationController.swift
//  WeatherReport
//
//  Created by Altug Parlak on 5.08.2023.
//

import Foundation

extension Data {
    func prettyPrintedJSONString() {
        guard
            let jsonObject = try?
               JSONSerialization.jsonObject(with: self,
               options: []),
            let jsonData = try?
               JSONSerialization.data(withJSONObject:
               jsonObject, options: [.prettyPrinted]),
            let prettyJSONString = String(data: jsonData,
               encoding: .utf8) else {
                print("Failed to read JSON Object.")
                return
        }
        print(prettyJSONString)
    }
}

class SearchLocationController {
    static let shared = SearchLocationController()
    
    enum SearchItemError: Error, LocalizedError {
        case locationsNotFound
        case imageDataMissing
        case invalidURL
        case detailError
    }
    
    func fetchLocations(matching query: [String: String]) async throws -> [SearchLocation] {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/geo/1.0/direct")!
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw SearchItemError.locationsNotFound
        }
        //data.prettyPrintedJSONString()
        let decoder = JSONDecoder()
        let searchLocations = try decoder.decode([SearchLocation].self, from: data)
        return searchLocations
    }
    
    func fetchLocationData(matching query: [String: String]) async throws -> SearchResponse2 {
        var urlComponents = URLComponents(string: "https://api.weatherapi.com/v1/current.json")!
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        //print(urlComponents.url ?? "ss")
        guard let url = urlComponents.url else {
            throw SearchItemError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw SearchItemError.locationsNotFound
            }
            //data.prettyPrintedJSONString()

            let decoder = JSONDecoder()
            let searchResponse = try decoder.decode(SearchResponse2.self, from: data)
            return searchResponse
        } catch {
            print("Error fetching location data:", error)
            throw SearchItemError.detailError
        }
    }


}
