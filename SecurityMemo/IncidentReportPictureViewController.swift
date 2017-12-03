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
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        imageView.image = self.delegate.incident.picture
    }
    
    
    @IBAction func doneBtnPressed(_ sender: UIBarButtonItem) {
        let (integrated, missing) = self.delegate.incident.check()
        if integrated {
            
            
            
            // Mocking database  ------------------------------------------------
            // upload to database
            let key = Utilities.convertCoordinateToKey(coord: self.delegate.incident.location!.coordinate!)
            if MockDatabase.database[key] == nil {
                MockDatabase.database[key] = []
            }
            MockDatabase.database[key]?.append(self.delegate.incident.makeCopy())
            
            //-----------------------------------------------------------------
//            self.ref.child("Location2").child("summary").setValue(self.delegate.incident.summary!)
//            self.ref.child("Location2").child("time").setValue(Utilities.dateCompToString(date: self.delegate.incident.dateTime!))
//            self.ref.child("Location").child("time").setValue(self.delegate.incident.Time!)
//            self.ref.child("Location2").child("des").setValue(self.delegate.incident.description!)
            
            
            
            
            //clear user input
            self.clear()

            // go to map view
            tabBarController?.selectedIndex = 0
            _ = navigationController?.popViewController(animated: true)
            return
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

}
