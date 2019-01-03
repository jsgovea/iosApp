//
//  Meal.swift
//  FoodClub
//
//  Created by Jorge Soto on 12/18/18.
//  Copyright © 2018 Jorge Soto. All rights reserved.
//

import UIKit
import SwiftyJSON

class Meal {
    var id: Int?
    var name: String?
    var description: String?
    var image: String?
    var price: Float?
    var cook_time: Int?
    
    init(json: JSON) {
        self.id = json["id"].int
        self.name = json["name"].string
        self.description = json["description"].string
        self.image = json["image"].string
        self.price = json["price"].float
        self.cook_time = json["cook_time"].int
    }
}
