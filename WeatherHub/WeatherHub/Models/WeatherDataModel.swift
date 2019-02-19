//
//  WeatherDataModel.swift
//  WeatherHub
//
//  Created by Siddharth Paneri on 18/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

struct WeatherDataModel {
    var year: Int16?
    var month: Int16?
    var temperatureMin: Double?
    var temperatureMax: Double?
    var rainfall: Double?
}


class WeatherDataParser {
    class func parse(_ weatherEntity: WeatherEntity) -> WeatherDataModel {
        var weatherModel = WeatherDataModel()
        weatherModel.year = weatherEntity.year
        weatherModel.month = weatherEntity.month
        weatherModel.temperatureMin = weatherEntity.temperatureMin
        weatherModel.temperatureMax = weatherEntity.temperatureMax
        weatherModel.rainfall = weatherEntity.rainfall
        return weatherModel
    }
    
    class func parse(_ weatherEntities: [WeatherEntity])-> [WeatherDataModel] {
        print("Parsing WeatherDataModel")
        var weatherModels: [WeatherDataModel]  = []
        for entity in  weatherEntities {
            weatherModels.append(WeatherDataParser.parse(entity))
        }
        return weatherModels
    }
}
