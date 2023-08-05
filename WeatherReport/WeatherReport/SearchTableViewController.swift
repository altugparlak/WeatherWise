//
//  SearchTableViewController.swift
//  WeatherReport
//
//  Created by Altug Parlak on 5.08.2023.
//

import UIKit

class SearchTableViewController: UITableViewController {

    @IBOutlet var searchBar: UISearchBar!
    
    var locations = [SearchLocation]()
    
    let searchLocationController = SearchLocationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func fetchMatchingLocations() {
        
        self.locations = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        
        if !searchTerm.isEmpty {
            
            let query = [
                "q": searchTerm,
                "limit": "5",
                "appid": ""
                // appid is your API key from https://openweathermap.org/api/one-call-3
            ]
            
            Task {
                do {
                    let searchLocations = try await searchLocationController.fetchLocations(matching: query)
                    self.locations = searchLocations
                    tableView.reloadData()
                    
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func configure(cell: ItemCell, forItemAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        cell.title = location.name
    }

    @IBSegueAction func showSearchLocation(_ coder: NSCoder, sender: Any?) -> LocationDetailViewController? {
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else {
                return nil
            }
            
        let searchLocation = locations[indexPath.row]

        return LocationDetailViewController(coder: coder, searchLocation: searchLocation)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationInfo", for: indexPath) as! ItemCell
        // Configure the cell...
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }

}

extension SearchTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchMatchingLocations()
        searchBar.resignFirstResponder()
    }
}
