//
//  MultiIncidentsDetailsViewController.swift
//  SecurityMemo
//
//  Created by Frank on 11/16/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import UIKit
import Firebase
class MultiIncidentsDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var incidents: [Incident]!
    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    // configure table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.incidents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
