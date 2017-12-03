//
//  ReportIncidentViewController.swift
//  SecurityMemo
//
//  Created by Frank on 11/12/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
class IncidentReportInfoViewController: UIViewController {

    var incident: Incident!  // preparing incident object
    private var locationManager: LocationManager! // location manager to get cur location
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var summaryInputField: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var useCurLocationSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateTimePickerView: UIDatePicker!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var ref: DatabaseReference!


    @IBOutlet weak var scrollView: UIScrollView!
    
    
    /*
     Initial configuration when view upload
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up border for description textView and imageView
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1
        
        // select .Others as default type
        self.typeSegment.selectedSegmentIndex = self.typeSegment.numberOfSegments - 1
        
        // default the use current location switch off
        useCurLocationSwitch.isOn = false
        
        // default incident date has to be within 7 days and not in the future
        dateTimePickerView.maximumDate = Date() // cannot report incident happeniing in futer
        dateTimePickerView.minimumDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        // initialize an incident
        self.incident = Incident()
        self.incident.dateTime = Calendar.current.dateComponents([.hour, .minute, .day, .month,.year], from: dateTimePickerView.date)
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: self.incident.dateTime!)!
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        self.incident.Time = formatter.string(from: date)
        
        self.incident.type = Incident.IncidentType.Others
        
        // initialize location manager
        self.locationManager = LocationManager()
        

        NotificationCenter.default.addObserver(self, selector: #selector(IncidentReportInfoViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(IncidentReportInfoViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func keyboardWillShow(_ notification:Notification) {
        
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
//        }
    }
    func keyboardWillHide(_ notification:Notification) {
        
//        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // black navigation title
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]

        // black every label text
        summaryLabel.textColor = UIColor.black
        locationLabel.textColor = UIColor.black
        timeLabel.textColor = UIColor.black
        descriptionLabel.textColor = UIColor.black

    }
    
    
    // summary text field
    @IBAction func summaryInputField(_ sender: UITextField) {
        self.incident.summary = sender.text
    }
    
    // get incident type from type segment
    @IBAction func typeSegementChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.incident.type = Incident.IncidentType.Robbery
            break
        case 1:
            self.incident.type = Incident.IncidentType.Theft
            break
        case 2:
            self.incident.type = Incident.IncidentType.Violent
            break
        case 3:
            self.incident.type = Incident.IncidentType.Burglary
            break
        default:
            self.incident.type = Incident.IncidentType.Others
            
        }
    }
   
    // get location from location input filed
    @IBAction func locationInputFiled(_ sender: UITextField) {
        // location can only be editted by users when useCurLocationSwitch is off, double check here
        if !useCurLocationSwitch.isOn {
            // for now assume the user could put valid address
            LocationManager.getCoordinateFromAddress(address: sender.text!, completionHandler: { (coordinate) in
                if coordinate != nil {
                    self.incident.location?.coordinate = coordinate
                    let l = CLLocation(latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!)
                    LocationManager.getAddressFromCoordinate(coordinate: l, completionHandler: { (address) in
                        self.incident.location?.name = address
                    })
                }
            })
        }
    }
    
    
    // switch for user current loction utility
    @IBAction func useCurLocationSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            disableLocationInput() // use current loction, instead of user's input
        }
        else {
            activateLoactionInput() // enable user input for loaction
        }
    }
    
    
    // get incident date and time from time picker
    @IBAction func datetimePickerChanged(_ sender: UIDatePicker) {
        self.incident.dateTime = Calendar.current.dateComponents([.hour, .minute, .day, .month,.year], from: sender.date)
    }
   
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        self.incident.description = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let (integrated, missing) = self.incident.check()
        if integrated || missing == Incident.MISS_PICTURE {
            return true
        }
        
        handleIncidentMissingComp(missingPart: missing)
        return false;
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? IncidentReportPictureViewController {
            destVC.delegate = self
        }
    }
    
    
    // Helper function disables location input field to make it showing current location
    private func disableLocationInput() {
        // disable user interaction
        locationTextField.isUserInteractionEnabled = false
        
        // get the address 
        if let location = self.locationManager.getCurCoordinate() {
            LocationManager.getAddressFromCoordinate(coordinate: location, completionHandler: { (curAddress) in
                self.locationTextField.text = curAddress
                
                // integrate incident
                self.incident.location?.name = curAddress
                self.incident.location?.coordinate = self.locationManager.getCurCoordinate()?.coordinate
            })
        }
        else {
            locationTextField.text = "Cannot find your current location!"
        }
    }
    
    // Helper function enables location input from user
    private func activateLoactionInput() {
        locationTextField.text = ""
        locationTextField.isUserInteractionEnabled = true
    }
    
    // Helper function handling incident missing compoennt
    private func handleIncidentMissingComp (missingPart: String!) {
        switch missingPart {
            case Incident.MISS_SUMMARY:
                summaryLabel.textColor = UIColor.red
                break
            case Incident.MISS_LOCATION:
                locationLabel.textColor = UIColor.red
                break
            case Incident.MISS_DATETIME:
                timeLabel.textColor = UIColor.red
                break
            case Incident.MISS_DESCRIPTION:
                descriptionLabel.textColor = UIColor.red
                break
            case Incident.MISS_PICTURE:
                break
            default: break // do nothing
        }
    }
    
    
    // clear out all user input
    func clear() {
        self.incident.clear()
        self.summaryInputField.text = ""
        self.useCurLocationSwitch.isOn = false
        self.activateLoactionInput()
        self.descriptionTextView.text = ""
        self.typeSegment.selectedSegmentIndex = self.typeSegment.numberOfSegments - 1
        self.incident.dateTime = Calendar.current.dateComponents([.hour, .minute, .day, .month,.year], from: dateTimePickerView.date)
    }
    
    
    


}
