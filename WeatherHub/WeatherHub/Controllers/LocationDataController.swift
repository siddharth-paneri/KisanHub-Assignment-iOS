//
//  LocationDataController.swift
//  WeatherHub
//
//  Created by Siddharth Paneri on 19/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation


class LocationDataController {
    
    private let dataProvider = DataProvider()
    
    /** Method to be used by View to store available locations in db */
    func store(locations: [Location]) {
        for location in locations {
            dataProvider.store(location: location)
        }
    }
    
}
