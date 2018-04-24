//
//  Weather.swift
//  JSON
//
//  Created by Tejasree Vangapalli on 18.04.18.
//  Copyright © 2018 Tejasree Vangapalli. All rights reserved.
//

import Foundation
import CoreLocation

struct Forecast {
//declaration of variables
    let day:String
    let icon:String
    let temperatureMax:Double
    let temperatureMin:Double

//any one of possible errors
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
//initialization of variables
    init(json:[String:Any]) throws {
        if let unixtime = json["time"] as? Double {
            let date = Date(timeIntervalSince1970: unixtime)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let day: String = dateFormatter.string(from: date)
            self.day = day
             } else {
            throw SerializationError.missing("day is missing")
            
        }
        
        if let icon = json["icon"] as? String {
            self.icon = icon
        } else {
            throw SerializationError.missing("icon is missing")
        }
        
        if let temperatureMax = json["temperatureMax"] as? Double {
           self.temperatureMax = temperatureMax
        } else {throw SerializationError.missing("temp is missing")}
        
        if let temperatureMin = json["temperatureMin"] as? Double {
            self.temperatureMin = temperatureMin
        }else {throw SerializationError.missing("temp is missing")}
    }
 
//base url of the weather forecast
    static let basePath = "https://api.darksky.net/forecast/caa9e10aef57f4c3e4bbfb6692484293/"
    
//retriving the contents of daily data which is in json format
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([Forecast]?) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        print(url)
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Forecast] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Forecast(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(forecastArray)
            }
        }
        task.resume()
    }
}
