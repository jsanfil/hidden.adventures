//
//  AdventureCollectionViewCell.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 5/27/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import ScalingCarousel
import Cosmos

class AdventureCollectionViewCell: ScalingCarouselCell {
  

    
    
    @IBOutlet weak var adventureImage: UIImageView!
    @IBOutlet weak var adventureName: UILabel!
    @IBOutlet weak var adventureAuthor: UILabel!
    @IBOutlet weak var adventureRating: CosmosView!
    
    override public func prepareForReuse() {
        // Ensures the reused cosmos view is as good as new
        adventureRating.prepareForReuse()
    }
    
}
