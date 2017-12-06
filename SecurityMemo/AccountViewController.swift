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
class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var incidents: [Incident] = []
    var ref: DatabaseReference!
    var username:String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        usernameLabel.text = Auth.auth().currentUser?.email!
        incidents = []
        fetchUserIncidents()
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
        print("user logged out")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func fetchUserIncidents() {
        //query specific
        
        if Auth.auth().currentUser != nil {
            // User is signed in.
            // ...
            self.incidents.removeAll()
            ref.child("Incidents").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                
                let dic = snapshot.value as? NSDictionary
                if dic == nil {
                    return
                }
                for(k,v) in dic!{
                    let tmp = v as?NSDictionary
                    for(k, v) in tmp!{
                        let info = v as?NSDictionary
                        let img:String = String(describing:info!["imageUrl"]!)
                        var i = MockDatabase.constructIncidentFromDatabase(ict: info!)
                        let imageRef = Storage.storage().reference(forURL: img)
                        imageRef.getData(maxSize: 150 * 1024 * 1024) { (data, error) in
                            if error != nil {
                                print("ERROR HAPPENED IN GETING IMAGE FROM URL")
                                print(error.debugDescription)
                                i.picture = UIImage(named: "pictureHolding")
                            }
                            else {
                                i.picture = UIImage(data: data!)!
                                
                            }
                            self.incidents.append(i)
                            self.tableView.reloadData()
                            
                        }
                        
                        
                        
                    }
                }
               
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            // No user is signed in.
            // ...
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // configure table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.incidents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Identifiers.MULTI_INCT_DETAIL_TV_CELL_ID, for: indexPath) as! IncidentDetailTableViewCell
        cell.incident = self.incidents[indexPath.row]
        return cell
    }
    
    // enable row click for more detailed view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.DETAIL_VC_ID) as! IncidentDetailViewController
        detailVC.incident = self.incidents[indexPath.row]
        print(self.incidents[indexPath.row].picture)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
