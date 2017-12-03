//
//  LoginViewController.swift
//  SecurityMemo
//
//  Created by Angelica Tao on 12/3/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import UIKit

var username:String = ""

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var login = true // true when login, false when register
    var password:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        errorLabel.alpha = 0
        usernameTF.text = ""
        passwordTF.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        errorLabel.alpha = 0
        usernameTF.text = ""
        passwordTF.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            login = true
            loginButton.setTitle("Login", for: .normal)
        }
        else {
            login = false
            loginButton.setTitle("Register", for: .normal)
        }
    }
    
    
    @IBAction func loginClicked(_ sender: UIButton) {
        username = usernameTF.text ?? ""
        password = passwordTF.text ?? ""
        
        if login {
            let loginVerified = verifyLogin(user: username, pass: password)
            if loginVerified {
                errorLabel.alpha = 0
                let accountVC = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.ACCT_VC_ID) as! AccountViewController
                accountVC.username = username
                self.navigationController?.pushViewController(accountVC, animated: true)
            }
            else {
                errorLabel.alpha = 1
            }
        }
        else { // register
            let registerSuccess = createUser(user: username, pass: password)
            if registerSuccess {
                errorLabel.alpha = 0
                let accountVC = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.ACCT_VC_ID) as! AccountViewController
                accountVC.username = username
                self.navigationController?.pushViewController(accountVC, animated: true)
            }
            else {
                errorLabel.alpha = 1
            }
        }
    }
    
    func verifyLogin(user: String, pass: String) -> Bool {
        return true
    }
    
    func createUser(user: String, pass: String) -> Bool {
        return true
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
