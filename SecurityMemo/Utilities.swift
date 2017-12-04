//
//  Utilities.swift
//  SecurityMemo
//
//  Created by Frank on 11/15/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import UIKit
import MapKit
import Firebase

// collection of functions for general purpose
class Utilities {
    
    // construct a key for the annotation which takes forms of "LA,latitude,LO,longitude"
    // this key is going to be used uniquely indentify the annotation
    public static func convertCoordinateToKey(coord: CLLocationCoordinate2D) -> String{
        //return "\(coord.latitude),\(coord.longitude)"
        return "LA,\(convertLongOrLat(l: String(coord.latitude))),LO,\(convertLongOrLat(l:String(coord.longitude)))"
    }
    
    
    // Resizes an image
    public static func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    // get a readable text from DateComponent
    public static func dateCompToString(date: DateComponents?) -> String {
        if date != nil {
            return "\(date!.year!)-\(date!.month!)-\(date!.day!)-\(date!.hour!):\(date!.minute!)"
        }
        return ""
    }
    
    // change the dot to "-"
    public static func convertLongOrLat(l: String) ->String {
        var chunks = l.components(separatedBy: ".")
        return "\(chunks[0])-\(chunks[1])"
    }
    
    
    // get incident type from its raw value
    public static func getIctTypeFromRaw(raw: String) -> Incident.IncidentType{
        switch raw {
        case Incident.IncidentType.Burglary.rawValue:
            return Incident.IncidentType.Burglary
        case Incident.IncidentType.Robbery.rawValue:
            return Incident.IncidentType.Robbery
        case Incident.IncidentType.Theft.rawValue:
            return Incident.IncidentType.Theft
        case Incident.IncidentType.Violent.rawValue:
            return Incident.IncidentType.Violent
        default:
            return Incident.IncidentType.Others
        }
    }
    
    
    // get a date from string format
    public static func getDateFromStr(dateStr: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH:mm"
        return dateFormatter.date(from: dateStr)!
        
    }
    
    // check if is between range
    public static func isBwtRange(start: Date, end: Date, target: Date) -> Bool {
        return (start ... end).contains(target)
    }
    
    
    
}
