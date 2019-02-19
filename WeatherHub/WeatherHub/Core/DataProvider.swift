//
//  DataProvider.swift
//  WeatherHub
//
//  Created by Siddharth Paneri on 18/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

class DataProvider {
    
    /** Function helps fetch weather data model for API, store in DB for given metric and location */
    func fetchWeatherData(for metric: Metric, and location: Location, _ completionHandler: @escaping ([WeatherDataModel])->()) {
        var params: [String: Any] = [:]
        params["Metric"] = metric.rawValue
        params["Location"] = location.rawValue
        CommsProvider.sharedInstance.request(type: .weatherData, params:params) { (response, error) in
            guard let result = response else {
                // fetch from DB
                let weatherData = WeatherEntity.fetchWeather(location: location)
                let parsedWeatherModel = WeatherDataParser.parse(weatherData)
                completionHandler(parsedWeatherModel)
                print("DataProvider: no response, fetch data from DB")
                return
            }
            
            if let weatherResponse = result as? [[String:Any]] {
                print("DataProvider: store data in DB")
                WeatherEntity.store(response: weatherResponse, with: metric, and: location)
                print("DataProvider: fetch data from DB")
                let weatherData = WeatherEntity.fetchWeather(location: location)
                let parsedWeatherModel = WeatherDataParser.parse(weatherData)
                completionHandler(parsedWeatherModel)
            }
        }
    }

    /** Function helps fetch weather data model from DB for given location and year */
    func fetchWeatherData(for location: Location, year: Int16) -> [WeatherDataModel] {
        let weatherData = WeatherEntity.fetchWeather(year: year, location: location)
        return WeatherDataParser.parse(weatherData)
    }
    
    
    // Interaction with location entity
    func store(location: Location) {
        LocationEntity.store(location: location)
    }
    
}
