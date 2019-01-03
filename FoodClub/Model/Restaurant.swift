//
//  Restaurant.swift
//  FoodClub
//
//  Created by Jorge Soto on 12/16/18.
//  Copyright © 2018 Jorge Soto. All rights reserved.
//

import UIKit
import SwiftyJSON

class Restaurant {
    var id: Int?
    var name: String?
    var address: String?
    var logo: String?
    var phone: String?
//    var category: String?
    
    init(json:  JSON){
        self.id = json["id"].int
        self.name = json["name"].string
        self.address = json["address"].string
        self.logo = json["logo"].string
        self.phone = json["phone"].string
//        self.category = (json[0]["category"].array as? String?)!
    }
}
