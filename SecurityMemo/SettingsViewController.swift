//
//  SettingsViewController.swift
//  securityMemo
//
//  Created by Angelica Tao on 11/19/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
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
    }
    
    @IBAction func startDateChanged(_ sender: UIDatePicker) {
        startDate = sender.date
    }
    
    
    @IBAction func endDateChanged(_ sender: UIDatePicker) {
        endDate = sender.date
    }
    

}
