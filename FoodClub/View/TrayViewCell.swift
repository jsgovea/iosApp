//
//  TrayViewCell.swift
//  FoodClub
//
//  Created by Jorge Soto on 1/1/19.
//  Copyright © 2019 Jorge Soto. All rights reserved.
//

import UIKit

class TrayViewCell: UITableViewCell {

    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var mealName: UILabel!
    
    @IBOutlet weak var subTotal: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        //quantityLabel.layer.borderColor = UIColor.gray.cgColor
        //quantityLabel.layer.borderWidth = 1.0
        //quantityLabel.layer.cornerRadius = 15
    }

}
