//
//  Incident.swift
//  SecurityMemo
//
//  Created by Frank on 11/13/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import UIKit
import CoreLocation

struct Location {
    var name: String?
    var coordinate: CLLocationCoordinate2D?
}

class Incident {
    
    enum IncidentType: String {
        case Robbery = "Robbery"
        case Theft = "Theft"
        case Violent = "Violent"
        case Burglary = "Burglary"
        case Others = "Others"
    }
    
    public static let MISS_SUMMARY = "summary"
    public static let MISS_LOCATION = "location"
    public static let MISS_DATETIME = "datetime"
    public static let MISS_DESCRIPTION = "description"
    public static let MISS_PICTURE  = "picture"
    
    var summary: String? = ""
    var type: IncidentType? = .Others
    var location: Location? = Location()
    var dateTime: DateComponents? = nil
    var Time: String? = nil
    var description: String? = nil
    var picture: UIImage? = nil
    

    
    // check if all propertities are presented
    public func check() -> (Bool, String) {
        if summary == "" {
            return (false, Incident.MISS_SUMMARY)
        }
        if location == nil || location?.name == nil || location?.coordinate == nil ||
            location?.coordinate?.longitude ==  nil || location?.coordinate?.latitude == nil {
            return (false, Incident.MISS_LOCATION)
        }
        
        if dateTime == nil || dateTime?.year == nil || dateTime?.month == nil || dateTime?.day == nil ||
            dateTime?.hour == nil || dateTime?.minute == nil {
            return (false, Incident.MISS_DATETIME)
        }
        if description == nil || description == "" {
            return (false, Incident.MISS_DESCRIPTION)
        }
        if picture  == nil {
            return (false, Incident.MISS_PICTURE)
        }
        
        return (true, "")
    }
    
    
    
    // clears all the properties
    public func clear() {
        self.summary = ""
        self.type = .Others
        self.location = Location()
        self.dateTime = nil
        self.description = nil
        self.picture = nil
    }
    
    
    // make a copy of itself
    public func makeCopy() -> Incident {
        let copy = Incident()
        copy.summary = self.summary
        copy.type = self.type
        copy.location = self.location
        copy.location?.name = self.location?.name
        copy.location?.coordinate = self.location?.coordinate
        copy.dateTime = self.dateTime
        copy.description = self.description
        copy.picture = self.picture
        return copy
    }
    
    
    
    
}
