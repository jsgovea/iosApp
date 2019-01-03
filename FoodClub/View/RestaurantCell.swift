//
//  RestaurantCell.swift
//  FoodClub
//
//  Created by Jorge Soto on 12/16/18.
//  Copyright © 2018 Jorge Soto. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {

    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet weak var restaurantAddress: UILabel!
    
    @IBOutlet weak var restaurantCategory: UILabel!
    
    @IBOutlet weak var restaurantLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    } 

}
