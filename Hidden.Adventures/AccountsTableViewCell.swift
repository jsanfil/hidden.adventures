//
//  AccountsTableViewCell.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 5/5/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit

class AccountsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profilePicImage: UIImageView!
    @IBOutlet weak var horizontalLineImage: UIImageView!
    @IBOutlet weak var adventureNumberLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var sidekickBtn: DesignableButton!
    
     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
}
