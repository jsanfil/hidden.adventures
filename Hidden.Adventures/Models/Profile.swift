//
//  Profile.swift
//  Hidden.Adventures
//
//  Created by Joe Sanfilippo on 2018-06-11.
//  Copyright © 2018 Jack Sanfilippo. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Profile: Mappable {
    var _id: String?
    var username: String?
    var city: String?
    var state: String?
    var email: String?
    var fullName: String?
    var profileImage: String?
    var backgroundImage: String?
    var isSidekick: Bool?
    
    required init(map: Map){
        isSidekick = false
    }
    
    init () {
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        username <- map["username"]
        city <- map["city"]
        state <- map["state"]
        email <- map["email"]
        fullName <- map["fullName"]
        profileImage <- map["profileImage"]
        backgroundImage <- map["backgroundImage"]
     }
}
