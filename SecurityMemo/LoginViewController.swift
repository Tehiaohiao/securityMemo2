//
//  LoginViewController.swift
//  SecurityMemo
//
//  Created by Angelica Tao on 12/3/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import UIKit
import Firebase
var username:String = ""
var uid:String = ""
class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var phoneNumTF: UITextField!
    
    var login = true // true when login, false when register
    var password:String = ""
    var phoneNumber:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        usernameTF.text = ""
        passwordTF.text = ""
        phoneNumTF.text = ""
        showPhone()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameTF.text = ""
        passwordTF.text = ""
        phoneNumTF.text = ""
        showPhone()
        username = ""
        uid = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPhone() {
        if login {
            loginButton.setTitle("Login", for: .normal)
            phoneNumTF.alpha = 0
            phoneNumLabel.alpha = 0
        }
        else {
            loginButton.setTitle("Register", for: .normal)
            phoneNumTF.alpha = 1
            phoneNumLabel.alpha = 1
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            login = true
            loginButton.setTitle("Login", for: .normal)
            phoneNumTF.alpha = 0
            phoneNumLabel.alpha = 0
        }
        else {
            login = false
            loginButton.setTitle("Register", for: .normal)
            phoneNumTF.alpha = 1
            phoneNumLabel.alpha = 1
        }
    }
    
    
    @IBAction func loginClicked(_ sender: UIButton) {
        username = usernameTF.text ?? ""
        password = passwordTF.text ?? ""
        phoneNumber = phoneNumTF.text ?? ""
        if login {
            verifyLogin(name: username, p: password)
        }
        else { // register
            createUser(name: username, p: password)
        }
    }
    
    func verifyLogin(name: String, p: String) -> Bool {
        
        Auth.auth().signIn(withEmail: name, password: p) { (user, error) in}
    
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
                
                let accountVC = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.ACCT_VC_ID) as! AccountViewController
                accountVC.username = username
                self.navigationController?.pushViewController(accountVC, animated: true)
            }
        }
        return false
    }
    
    func createUser(name: String, p: String) -> Bool {
        
        Auth.auth().createUser(withEmail: name, password: p) { (user, error) in}
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
                let accountVC = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.ACCT_VC_ID) as! AccountViewController
                accountVC.username = username
                self.navigationController?.pushViewController(accountVC, animated: true)
            }
        }
        return false
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
