//
//  Sidekick.swift
//  Hidden.Adventures
//
//  Created by Joe Sanfilippo on 2018-07-01.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Sidekick: Mappable {
    var _id: String?
    var username: String?
    var sidekickName: String?
    var sidekickImage: String?
    
    required init(map: Map){
    }
    
    init () {
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        username <- map["username"]
        sidekickName <- map["sidekickName"]
        sidekickImage <- map["sidekickImage"]
   }
}
