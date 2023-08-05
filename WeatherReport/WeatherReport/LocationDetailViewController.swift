//
//  LocationDetailViewController.swift
//  WeatherReport
//
//  Created by Altug Parlak on 5.08.2023.
//

import UIKit

class LocationDetailViewController: UIViewController {
    @IBOutlet var locationNameLabel: UILabel!
    @IBOutlet var locationTemperatureLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    let searchLocation:SearchLocation
    var searchData: SearchResponse2?
    
    init?(coder: NSCoder, searchLocation: SearchLocation) {
        self.searchLocation = searchLocation
        self.searchData = nil
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocationInfo()
        // Do any additional setup after loading the view.
    }
    
    func fetchLocationInfo() {
        //q=lat,lon
        let query = [
            // key is your API key from https://www.weatherapi.com/
            "key": "",
            "q": "\(searchLocation.lat),\(searchLocation.lon)",
            "aqi": "no"
        ]

        Task {
            do {
                let searchData = try await SearchLocationController.shared.fetchLocationData(matching: query)
                self.searchData = searchData
                updateUI()
            } catch {
                print(error)
            }
        }
    }
    
    func updateUI() {
        if let searchData = searchData {
            locationNameLabel.text = searchData.location.name
            locationTemperatureLabel.text = "\(searchData.current.temp)°C"
            infoLabel.text = searchData.current.condition.text
            windSpeedLabel.text = "\(searchData.current.windSpeed) kph"
            windDirectionLabel.text = searchData.current.windDir
            humidityLabel.text = "\(searchData.current.humidity)"
            if let iconURLString = searchData.current.condition.icon,
               let iconURL = URL(string: "https:" + iconURLString) {
                URLSession.shared.dataTask(with: iconURL) { data, _, error in
                    if let error = error {
                        print("Error fetching icon image:", error)
                        return
                    }

                    if let data = data, let iconImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.iconImage.image = iconImage
                        }
                    }
                }.resume()
            }
        } else {
            locationNameLabel.text = ""
            locationTemperatureLabel.text = ""
            infoLabel.text = ""
            windSpeedLabel.text = ""
            windDirectionLabel.text = ""
            humidityLabel.text = ""
        }
    }

}
