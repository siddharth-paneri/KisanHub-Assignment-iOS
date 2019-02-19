//
//  Enums.swift
//  WeatherHub
//
//  Created by Siddharth Paneri on 18/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

enum Metric: String {
    case temperatureMax = "Tmax"
    case temperatureMin = "Tmin"
    case rainfall = "Rainfall"
}

enum Location: String {
    case uk = "UK"
    case england = "England"
    case scotland = "Scotland"
    case wales = "Wales"
}

enum Segue: String {
    case weatherData = "WeatherData"
}
