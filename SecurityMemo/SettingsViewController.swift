//
//  SettingsViewController.swift
//  securityMemo
//
//  Created by Angelica Tao on 11/19/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var receiveTextSwitch: UISwitch!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var incidentTypeControl: UISegmentedControl!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    var receiveText:Bool = true
    var locationString:String = ""
    var radius:Float = 0
    var incidentType:Incident.IncidentType = Incident.IncidentType.Robbery
    var startDate:Date = NSDate() as Date
    var endDate:Date = NSDate() as Date
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        ref = Database.database().reference()
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func newLocationEntered(_ sender: Any) {
        
        locationString = locationTextField.text ?? ""
        if checkuser(){
            self.ref.child("users").child(uid).child("username").setValue(username)
            self.ref.child("users").child(uid).child("loc").setValue(locationString)
            self.ref.child("users").child(uid).child("type").setValue(incidentType.rawValue)
            self.ref.child("users").child(uid).child("start").setValue(Utilities.dateCompToString(date: Calendar.current.dateComponents([.hour, .minute, .day, .month,.year], from: startDate)))
            self.ref.child("users").child(uid).child("end").setValue(Utilities.dateCompToString(date: Calendar.current.dateComponents([.hour, .minute, .day, .month,.year], from: endDate)))
            
            
        }
    }
    
    
    @IBAction func radiusChanged(_ sender: Any) {
        radius = radiusSlider.value
    }
    
    @IBAction func incidentTypeChanged(_ sender: Any) {
        switch incidentTypeControl.selectedSegmentIndex {
        case 0:
            incidentType = Incident.IncidentType.Robbery
            break
        case 1:
            incidentType = Incident.IncidentType.Theft
            break
        case 2:
            incidentType = Incident.IncidentType.Violent
            break
        case 3:
            incidentType = Incident.IncidentType.Burglary
            break
        default:
            incidentType = Incident.IncidentType.Others
            
        }
        if checkuser(){
            self.ref.child("users").child(uid).child("username").setValue(username)
            self.ref.child("users").child(uid).child("loc").setValue(locationString)
            self.ref.child("users").child(uid).child("type").setValue(incidentType.rawValue)
            self.ref.child("users").child(uid).child("start").setValue(Utilities.dateCompToString(date: Calendar.current.dateComponents([.hour, .minute, .day, .month,.year], from: startDate)))
            self.ref.child("users").child(uid).child("end").setValue(Utilities.dateCompToString(date: Calendar.current.dateComponents([.hour, .minute, .day, .month,.year], from: endDate)))
            
        }
    }
    
    @IBAction func startDateChanged(_ sender: UIDatePicker) {
        startDate = sender.date
        if checkuser(){
            self.ref.child("users").child(uid).child("username").setValue(username)
            self.ref.child("users").child(uid).child("loc").setValue(locationString)
            self.ref.child("users").child(uid).child("type").setValue(incidentType.rawValue)
            self.ref.child("users").child(uid).child("start").setValue(Utilities.dateCompToString(date: Calendar.current.dateComponents([.hour, .minute, .day, .month,.year], from: startDate)))
            self.ref.child("users").child(uid).child("end").setValue(Utilities.dateCompToString(date: Calendar.current.dateComponents([.hour, .minute, .day, .month,.year], from: endDate)))
            
        }
    }
    
    
    @IBAction func endDateChanged(_ sender: UIDatePicker) {
        endDate = sender.date
        if checkuser(){
            self.ref.child("users").child(uid).child("username").setValue(username)
            self.ref.child("users").child(uid).child("loc").setValue(locationString)
            self.ref.child("users").child(uid).child("type").setValue(incidentType.rawValue)
            self.ref.child("users").child(uid).child("start").setValue(Utilities.dateCompToString(date: Calendar.current.dateComponents([.hour, .minute, .day, .month,.year], from: startDate)))
            self.ref.child("users").child(uid).child("end").setValue(Utilities.dateCompToString(date: Calendar.current.dateComponents([.hour, .minute, .day, .month,.year], from: endDate)))
            
        }
        
    }
    func checkuser()-> Bool{
        if Auth.auth().currentUser != nil {
            // User is signed in.
            // ...
            let user = Auth.auth().currentUser
            if let user = user {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                uid = user.uid
                username =  user.email!
                return true;
            }
        }
        return false
    }
    
    
}
