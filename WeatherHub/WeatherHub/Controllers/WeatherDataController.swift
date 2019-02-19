//
//  WeatherDataController.swift
//  WeatherHub
//
//  Created by Siddharth Paneri on 18/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

class WeatherDataController {
    private let dataProvider = DataProvider()
    
    /** This method is supposed to be used by View to fetch data from API/DB */
    func fetchWeatherData(for metric: Metric, and location: Location, _ completionHandler: @escaping ([WeatherDataModel])->()) {
        dataProvider.fetchWeatherData(for: metric, and: location) { (weatherData) in
            completionHandler(weatherData)
        }
    }
    
    
    /** This method is supposed to be used by View to fetch data from DB */
    func fetchWeatherData(for location: Location, year: Int16) -> [WeatherDataModel] {
        return dataProvider.fetchWeatherData(for: location, year: year)
    }
    
}
