//
//  IncidentPictureViewController.swift
//  SecurityMemo
//
//  Created by Frank on 11/14/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import UIKit
import Firebase
class IncidentReportPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    weak var delegate: IncidentReportInfoViewController!
    @IBOutlet weak var imageView: UIImageView!
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.databaseRef = Database.database().reference().child("Incidents") // 　database reference to incidents
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        imageView.image = self.delegate.incident.picture
    }
    
    
    @IBAction func doneBtnPressed(_ sender: UIBarButtonItem) {
        let (integrated, missing) = self.delegate.incident.check()
        if integrated {
            
            
            /*
            // Mocking database  ------------------------------------------------
            // upload to database
            let key = Utilities.convertCoordinateToKey(coord: self.delegate.incident.location!.coordinate!)
            if MockDatabase.database[key] == nil {
                MockDatabase.database[key] = []
            }
            MockDatabase.database[key]?.append(self.delegate.incident.makeCopy())
            
            */
            
            // create a storage reference and call upload
            //get a time key with incident datetime
            let dateTimeKey = Utilities.dateCompToString(date: self.delegate.incident.dateTime)
            let randomNum = arc4random()
            print("userA\(dateTimeKey)\(randomNum).png")
            let storageRef = Storage.storage().reference().child("userA\(dateTimeKey)\(randomNum).png")
            if let uploadData = UIImagePNGRepresentation(self.delegate.incident.picture!) {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print("ERROR IN UPLOADING IMAGE TO STORAGE")
                        self.uploadIncident(picUrl: nil)
                    }
                    else {
                        self.uploadIncident(picUrl: (metadata?.downloadURL()?.absoluteString)!)
                    }
                }
            }
        }
        if !integrated && missing == Incident.MISS_PICTURE {
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.red]
        }
        else {
            print("Unexpected part missing for incident: \(missing)")
        }
    }
    
    
    @IBAction func camBtnPressed(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func photoLibBtnPressed(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            self.delegate.incident.picture = imageView.image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    // clear out user input image
    func clear() {
        self.delegate.clear()
        self.imageView.image = nil
    }
    
    // upload incident to firebase
    func uploadIncident(picUrl: String?) {
        
        if picUrl != nil {
            self.delegate.incident.pictureUrl = picUrl
        }
        
        var userId = uid
        if uid == "" || uid.trimmingCharacters(in: .whitespaces).isEmpty{
            userId = "NON-USER"
        }
        
        //get a inciddent key with location
        let incidentKey = Utilities.convertCoordinateToKey(coord: (self.delegate.incident.location?.coordinate)!)
        //get a time key with incident datetime
        let dateTimeKey = Utilities.dateCompToString(date: self.delegate.incident.dateTime)
        
        self.databaseRef.child(userId).child(incidentKey).child(dateTimeKey).child("summay").setValue(self.delegate.incident.summary!)
        self.databaseRef.child(userId).child(incidentKey).child(dateTimeKey).child("type").setValue(self.delegate.incident.type?.rawValue)
        self.databaseRef.child(userId).child(incidentKey).child(dateTimeKey).child("datatime").setValue(Utilities.dateCompToString(date: self.delegate.incident.dateTime))
        self.databaseRef.child(userId).child(incidentKey).child(dateTimeKey).child("description").setValue(self.delegate.incident.description!)
        self.databaseRef.child(userId).child(incidentKey).child(dateTimeKey).child("imageUrl").setValue(self.delegate.incident.pictureUrl)
        self.databaseRef.child(userId).child(incidentKey).child(dateTimeKey).child("lat").setValue(self.delegate.incident.location?.coordinate?.latitude)
        self.databaseRef.child(userId).child(incidentKey).child(dateTimeKey).child("long").setValue(self.delegate.incident.location?.coordinate?.longitude)
        self.databaseRef.child(userId).child(incidentKey).child(dateTimeKey).child("addressName").setValue(self.delegate.incident.location?.name!)
        
        
        //clear user input
        self.clear()
        
        // go to map view
        tabBarController?.selectedIndex = 0
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    
}
