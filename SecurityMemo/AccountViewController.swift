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
    @IBOutlet weak var tableView: UITableView!
    
    
    var incidents: [Incident] = []
    var ref: DatabaseReference!
    var username:String = ""

    
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
        print("user logged out")
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func fetchUserIncidents() {
        //query specific
        if Auth.auth().currentUser != nil {
            // User is signed in.
            // ...
            ref.child("Incidents").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let dic = snapshot.value as? NSDictionary
                for(k,v) in dic!{
                    let tmp = v as?NSDictionary
                    for(k, v) in tmp!{
                        let info = v as?NSDictionary
                        let datetime:String? = String(describing:info!["datatime"]!)
                        let des:String? = String(describing:info!["description"]!)
                        let img:String? = String(describing:info!["imageUrl"]!)
                        let lat:String? = String(describing:info!["lat"]!)
                        let long:String? = String(describing:info!["long"]!)
                        let summary:String? = String(describing:info!["summay"]!)
                        let type:String? = String(describing:info!["type"]!)
                        let address:String? = String(describing:info!["addressName"]!)
                        var i: Incident!
                        i.Time = datetime
                        i.description = des
                        i.summary = summary
                        var Coordinates = CLLocationCoordinate2D(latitude: Double(lat!) as!
                            CLLocationDegrees, longitude: Double(long!) as! CLLocationDegrees)
                        var loc = Location()
                        loc.name = address
                        loc.coordinate = Coordinates
                        i.location = loc
                        //i.picture = img
                        
                        let key = Utilities.convertCoordinateToKey(coord: i.location!.coordinate!)
                        if MockDatabase.database[key] == nil {
                            MockDatabase.database[key] = []
                        }
                        MockDatabase.database[key]?.append(i.makeCopy())
                        
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
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: Identifiers.DETAIL_VC_ID) as! IncidentDetailViewController
        detailVC.incident = self.incidents[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
