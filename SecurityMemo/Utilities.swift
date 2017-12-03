//
//  Utilities.swift
//  SecurityMemo
//
//  Created by Frank on 11/15/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import UIKit
import MapKit

// collection of functions for general purpose
class Utilities {
    
    // construct a key for the annotation which takes forms of "LA-latitude,LO-longitude"
    // this key is going to be used uniquely indentify the annotation
    public static func convertCoordinateToKey(coord: CLLocationCoordinate2D) -> String{
        return "\(coord.latitude),\(coord.longitude)"
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
            return "\(date!.hour!):\(date!.minute!) \(date!.year!)-\(date!.month!)-\(date!.day!)"
        }
        return ""
    }

}
