//
//  AccountViewController.swift
//  SecurityMemo
//
//  Created by Angelica Tao on 12/3/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import UIKit
import Firebase
import MapKit
class AccountViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    var username:String = ""
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
        usernameLabel.text = username
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameLabel.text = username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("user loged out")
        self.navigationController?.popViewController(animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
