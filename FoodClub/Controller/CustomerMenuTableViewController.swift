//
//  CustomerMenuTableViewController.swift
//  FoodClub
//
//  Created by Jorge Soto on 12/11/18.
//  Copyright © 2018 Jorge Soto. All rights reserved.
//

import UIKit
import Alamofire

class CustomerMenuTableViewController: UITableViewController {
    
    
    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var imageAvatar: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullName.text = User.currentUser.name
        
        imageAvatar.image = try! UIImage(data: Data(contentsOf: URL(string: User.currentUser.pictureURL!)!))
        
    
        imageAvatar.layer.cornerRadius = 70 / 2
        imageAvatar.layer.borderWidth = 1.0
        
        
    }
    
}
