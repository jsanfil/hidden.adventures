//
//  Adventure.swift
//  Adventures
//
//  Created by Joe Sanfilippo on 2018-03-18.
//  Copyright © 2018 Joe Sanfilippo. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Location: Mappable {
    var _id: String?
    var type: String?
    var coordinates: [Double]?
    
    required init(map: Map){
    }
    
    init () {
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        type <- map["type"]
        coordinates <- map["coordinates"]
    }
}

class Adventure: Mappable {
    var _id: String?
    var name: String?
    var desc: String?
    var author: String?
    var access: String?
    var defaultImage: String?
    var category: String?
    var images: [String]?
    var location: Location?
    var rating: Double?
    var ratingCount: Int?
    var acl: [String]?
    
    required init(map: Map){
        self.defaultImage = "defaultPhoto"
        self.access = "private"
    }
    
    init () {
    }
    
    func mapping(map: Map) {
        _id <- map["_id"]
        name <- map["name"]
        desc <- map["desc"]
        author <- map["author"]
        access <- map["access"]
        defaultImage <- map["defaultImage"]
        category <- map["category"]
        images <- map["images"]
        location <- map["location"]
        rating <- map["rating"]
        ratingCount <- map["ratingCount"]
        acl <- map["acl"]
    }
}
