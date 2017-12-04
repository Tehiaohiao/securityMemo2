//
//  MockingDatabase.swift
//  SecurityMemo
//
//  Created by Frank on 11/15/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import Foundation
import Firebase
import MapKit
class MockDatabase {
    
    
    
    public static var database: [String: [Incident]] = [:] 
    
    
    // function fetch data from firebase and populate the mapveiw
    public static func fillDatabase(mapVC: IncidentMapViewController) {
        // clear current database
        MockDatabase.database.removeAll()
        
        // fetch incident from database
        let databaseRef = Database.database().reference()
        databaseRef.child("Incidents").observeSingleEvent(of: .value, with: { (snapshot) in
            let data = snapshot.value as? [String: NSDictionary] ?? [:]
            for (_, locDic) in data {
                for (locKey, timeDic) in locDic {
                    // make a key for the loc key
                    if MockDatabase.database[locKey as! String] == nil {
                        MockDatabase.database[locKey as! String] = []
                    }
                    
                    for (_, ict) in (timeDic as? NSDictionary)! {
                        let ictDic = ict as! NSDictionary
                        let incident = constructIncidentFromDatabase(ict: ictDic)
                        let url = ictDic["imageUrl"] as! String                        
                        let imageRef = Storage.storage().reference(forURL: url)
                        imageRef.getData(maxSize: 15 * 1024 * 1024) { (data, error) in
                            if error != nil {
                                print("ERROR HAPPENED IN GETING IMAGE FROM URL")
                                print(error.debugDescription)
                                incident.picture = UIImage(named: "pictureHolding")
                            }
                            else {
                                incident.picture = UIImage(data: data!)!
                                
                            }
                            MockDatabase.database[locKey as! String]?.append(incident)
                            mapVC.mapView.addAnnotation(IncidentPinAnnotation(key: locKey as! String))
                        }
                    }
                }
            }
        })
    }
    
    
    // convert a stored incident to a incident object
    public static func constructIncidentFromDatabase(ict: NSDictionary) -> Incident{
        
        // create datetime component
        let dateCompStrArr = (ict["datatime"] as! String).components(separatedBy: "-")
        var datetimeComp = DateComponents.init()
        datetimeComp.year = Int(dateCompStrArr[0])
        datetimeComp.month = Int(dateCompStrArr[1])
        datetimeComp.day = Int(dateCompStrArr[2])
        datetimeComp.hour = Int(dateCompStrArr[3].components(separatedBy: ":")[0])
        datetimeComp.minute = Int(dateCompStrArr[3].components(separatedBy: ":")[1])
        
        // create location
        let cord = CLLocationCoordinate2D(latitude: ict["lat"]! as!
            CLLocationDegrees, longitude: ict["long"]! as! CLLocationDegrees)
        var location = Location()
        location.name = ict["addressName"] as? String
        location.coordinate = cord
    
        // build a incident
        let newIct: Incident = Incident()
        newIct.summary = ict["summay"] as? String
        newIct.description = ict["description"] as? String
        newIct.type = Utilities.getIctTypeFromRaw(raw: (ict["type"] as? String)!)
        newIct.dateTime = datetimeComp
        newIct.location = location
    
        return newIct
    }
    
    
    
}
