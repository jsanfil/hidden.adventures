//
//  Favorite.swift
//  Hidden.Adventures
//
//  Created by Joe Sanfilippo on 1/12/19.
//  Copyright © 2019 Jack Sanfilippo. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Favorite: Mappable {
    var _id: String?
    var username: String?
    var adventureID: String?
    
    required init(map: Map){
    }
    
    init () {
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        username <- map["username"]
        adventureID <- map["adventureID"]
      }
}
