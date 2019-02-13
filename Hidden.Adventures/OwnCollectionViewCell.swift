//
//  OwnCollectionViewCell.swift
//  Hidden.Adventures
//
//  Created by Jack Sanfilippo on 5/29/18.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import UIKit
import ScalingCarousel
import Cosmos

class OwnCollectionViewCell: ScalingCarouselCell {
    @IBOutlet weak var adventureTitle: UILabel!
    @IBOutlet weak var adventureImage: UIImageView!
    @IBOutlet weak var adventureRating: CosmosView!
}
