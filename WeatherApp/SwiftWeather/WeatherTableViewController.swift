//
//  WeatherTableViewController.swift
//  SwiftWeather
//
//  Created by Tejasree Vangapalli on 18/04/18.
//  Copyright © 2018 Tejasree Vangapalli. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, UISearchBarDelegate {
//search bar outlet declaration
    @IBOutlet weak var searchBar: UISearchBar!
    
//forecast type variable
    var forecastData = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        updateWeatherForLocation(location: "Stillwater")
    }
 
//search function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
        }
    }
  
//weather forecast for every search through 2D latitude and longitude
    func updateWeatherForLocation (location:String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    Forecast.forecast(withLocation: location.coordinate, completion: { (results:[Forecast]?) in
                        
                        if let weatherData = results {
                            self.forecastData = weatherData
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                        
                    })
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//Number of cells
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forecastData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

//output of each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell

        let weatherObject = forecastData[indexPath.section]
 
        cell.dayLabel?.text = weatherObject.day
        cell.artistImageView?.image = UIImage(named: weatherObject.icon)
        cell.tempLabel?.text = "\(Int(weatherObject.temperatureMin)) °F , \(Int(weatherObject.temperatureMax)) °F"
        
        return cell
    }
 }
