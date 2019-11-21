//
//  Place.swift
//  FavoritePlaces
//
//  Created by C4Q on 11/21/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Place: NSObject, MKAnnotation {
    let title: String?
    let creatorID: String
    let lat: Double
    let long: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
    }
    
    init(title: String, creatorID: String, lat: Double, long: Double) {
        self.title = title
        self.creatorID = creatorID
        self.lat = lat
        self.long = long
    }
    
    
    init?(from dict: [String: Any]) {
        guard let title = dict["title"] as? String,
        let creatorID = dict["creatorID"] as? String,
        let lat = dict["lat"] as? Double,
        let long = dict["long"] as? Double
            else {return nil}
        self.title = title
        self.creatorID = creatorID
        self.lat = lat
        self.long = long
        
    }
    
    var fieldsDict: [String: Any] {
        return ["title": self.title ?? "N/A",
                "creatorID": self.creatorID,
                "lat": self.lat,
                "long": self.long]
    }
    
    
    
}
