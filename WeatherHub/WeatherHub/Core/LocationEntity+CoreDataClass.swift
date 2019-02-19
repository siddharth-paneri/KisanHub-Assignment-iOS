//
//  LocationEntity+CoreDataClass.swift
//  WeatherHub
//
//  Created by Siddharth Paneri on 18/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftRecord

@objc(LocationEntity)
public class LocationEntity: NSManagedObject {
    
    class func fetchLocations() -> [LocationEntity] {
        return LocationEntity.all(sort: [["name": "ASC"]]) as! [LocationEntity]
    }
    
    class func fetchLocation(with name: String) -> LocationEntity? {
        return LocationEntity.find("name = %@", args: name) as? LocationEntity
    }
    
    
    class func store(location: Location) {
        var locationEntity: LocationEntity? = nil
        if let locationObj = LocationEntity.fetchLocation(with: location.rawValue){
            locationEntity = locationObj
        } else {
            locationEntity = LocationEntity.create() as? LocationEntity
            locationEntity?.setValue(location.rawValue, forKey: "name")
        }
        _ = locationEntity?.save()
    }
}
