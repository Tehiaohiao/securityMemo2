//
//  IncidentDetailTableViewCell.swift
//  SecurityMemo
//
//  Created by Frank on 11/16/17.
//  Copyright © 2017 SecurityMemoTeam. All rights reserved.
//

import UIKit

class IncidentDetailTableViewCell: UITableViewCell {
    
    var incident: Incident? {
        didSet {
            self.detailTextLabel?.numberOfLines = 0
            self.textLabel?.text = incident?.summary!
            self.detailTextLabel?.text = "Type: \(incident!.type!.rawValue) \n Time: \(Utilities.dateCompToString(date: incident!.dateTime!))"
            self.imageView?.image = incident?.picture
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 20
        self.backgroundColor = self.superview?.backgroundColor
        self.textLabel?.textColor = UIColor.black
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
