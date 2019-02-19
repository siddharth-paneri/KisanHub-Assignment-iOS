//
//  WeatherEntity+CoreDataClass.swift
//  WeatherHub
//
//  Created by Siddharth Paneri on 19/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData

@objc(WeatherEntity)
public class WeatherEntity: NSManagedObject {
    
    class func fetchWeather(year: Int16, month: Int16, location: Location) -> WeatherEntity? {
        return WeatherEntity.find(["year": year, "month": month, "location.name": location.rawValue], sort: [["year": "ASC"]]) as? WeatherEntity
    }
    
    class func fetchWeather(year: Int16, location: Location) -> [WeatherEntity] {
        return WeatherEntity.query(["year": year, "location.name":location.rawValue], sort: [["year" : "ASC"], ["month":"ASC"]]) as! [WeatherEntity]
    }
    
    class func fetchWeather(location: Location) -> [WeatherEntity] {
        return WeatherEntity.query(["location.name":location.rawValue], sort: [["year" : "ASC"], ["month":"ASC"]]) as! [WeatherEntity]
    }
    
    class func store(response: [[String: Any]], with metric: Metric, and location: Location) {
        var managedObjects: [NSManagedObject] = []
        for dic in response {
            if let year = dic["year"] as? Int16 {
                if let month = dic["month"] as? Int16 {
                    
                    var coreDataObj: NSManagedObject? = nil
                    if let data = WeatherEntity.fetchWeather(year: year, month: month, location: location) {
                        coreDataObj = data
                    } else {
                        coreDataObj = WeatherEntity.create()
                    }
                    
                    guard let weatherDataObject = coreDataObj else {
                        break
                    }
                    
                    weatherDataObject.setValue(year, forKey: "year")
                    weatherDataObject.setValue(month, forKey: "month")
                    
                    if let value = dic["value"] as? Double {
                        switch metric {
                        case .temperatureMax:
                            weatherDataObject.setValue(value, forKey: "temperatureMax")
                            break
                        case .temperatureMin:
                            weatherDataObject.setValue(value, forKey: "temperatureMin")
                            break
                        case .rainfall:
                            weatherDataObject.setValue(value, forKey: "rainfall")
                            break
                        }
                    }
                    
                    var locationEntity = LocationEntity.fetchLocation(with: location.rawValue)
                    if locationEntity == nil {
                        locationEntity = LocationEntity.create() as? LocationEntity
                        locationEntity?.setValue(location.rawValue, forKey: "name")
                    }
                    weatherDataObject.setValue(locationEntity, forKey: "location")
                    managedObjects.append(weatherDataObject)
                }
            }
        }
        if managedObjects.count > 0 {
            _ = managedObjects[managedObjects.count-1].save()
        }
    }
    
}
