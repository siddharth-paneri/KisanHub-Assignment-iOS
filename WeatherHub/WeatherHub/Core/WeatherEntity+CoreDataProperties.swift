//
//  WeatherEntity+CoreDataProperties.swift
//  WeatherHub
//
//  Created by Siddharth Paneri on 19/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherEntity> {
        return NSFetchRequest<WeatherEntity>(entityName: "WeatherEntity")
    }

    @NSManaged public var rainfall: Double
    @NSManaged public var temperatureMax: Double
    @NSManaged public var temperatureMin: Double
    @NSManaged public var year: Int16
    @NSManaged public var month: Int16
    @NSManaged public var location: LocationEntity?

}
