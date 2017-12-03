
//
//  IncidentPinAnnotation.swift
//  SecurityMemo
//
//  Created by Frank on 11/15/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//
import UIKit
import MapKit

// customized annotation
class IncidentPinAnnotation: MKPointAnnotation {
    
    var key: String!

    init(key: String) {
        super.init()
        if MockDatabase.database[key] == nil || MockDatabase.database[key]!.count <= 0 || !MockDatabase.database[key]!.first!.check().0 {
            print("CANNOT GET ANNOTATION FOR AN INVALID INCIDENT")
            return
        }
        self.key = key
        self.coordinate = (MockDatabase.database[self.key]?.first?.location?.coordinate)!
        self.title = MockDatabase.database[self.key]?.first?.location?.name
        self.subtitle = self.getSubTitle()
    }
    
    // get the name of image for the pin from the incident type
    public func getPinImageName() -> String{
        
        if MockDatabase.database[self.key]?.count == 1 {
            let incident = MockDatabase.database[self.key]?.first
            switch incident!.type! {
            case Incident.IncidentType.Robbery:
                return "robberyPin"
            case Incident.IncidentType.Theft:
                return "theftPin"
            case Incident.IncidentType.Violent:
                return "violentPin"
            case Incident.IncidentType.Burglary:
                return "burglaryPin"
            default:
                return "othersPin"
            }
        }
        return "multiplePin"
    }
    
    
    
    // get displaying text for subtitle by collecting all reported incidents
    public func getSubTitle() -> String{
        
        var ans: [Incident.IncidentType: Int] = [Incident.IncidentType.Robbery : 0]
        ans[Incident.IncidentType.Theft] = 0
        ans[Incident.IncidentType.Violent] = 0
        ans[Incident.IncidentType.Burglary] = 0
        ans[Incident.IncidentType.Others] = 0
        
        for incident in MockDatabase.database[self.key]! {
            ans[incident.type!]! += 1
        }
        
        return "R(\(ans[Incident.IncidentType.Robbery]!)), T(\(ans[Incident.IncidentType.Theft]!)), V(\(ans[Incident.IncidentType.Violent]!)), B(\(ans[Incident.IncidentType.Burglary]!)), O(\(ans[Incident.IncidentType.Others]!))"
    }
    
    
}
