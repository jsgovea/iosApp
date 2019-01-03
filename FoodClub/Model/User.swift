//
//  User.swift
//  FoodClub
//
//  Created by Jorge Soto on 12/11/18.
//  Copyright © 2018 Jorge Soto. All rights reserved.
//

import Foundation
import SwiftyJSON

class User {
    var name: String?
    var email: String?
    var pictureURL: String?
    var id: String?
    
    static let currentUser = User()
    
    func setInfo(json: JSON) {
        self.name = json["name"].string
        self.email = json["email"].string
        self.id = json["id"].string
        
        let image = json["picture"].dictionary
        let imageData = image?["data"]?.dictionary
        
        self.pictureURL = imageData?["url"]?.string
    }
    
    func resetInfo()
    {
        name = nil
        email = nil
        id = nil
        pictureURL = nil
    }
   
}
