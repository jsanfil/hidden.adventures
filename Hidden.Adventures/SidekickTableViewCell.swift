//
//  SidekickTableViewCell.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 5/8/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit

class SidekickTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
