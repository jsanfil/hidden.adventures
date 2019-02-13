//
//  Message.swift
//  Hidden.Adventures
//
//  Created by Joe Sanfilippo on 1/24/19.
//  Copyright © 2019 Jack Sanfilippo. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Message: Mappable {
    var _id: String?
    var username: String?
    var msgType: String?
    var body: String?
    
    required init(map: Map){
    }
    
    init () {
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        username <- map["username"]
        msgType <- map["msgType"]
        body <- map["body"]
    }
}

