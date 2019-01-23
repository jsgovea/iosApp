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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "CustomerLogout" {
            
            APIManager.shared.logout(completionHandler: { (error) in
                if error == nil {
                    FBManager.shared.logOut()
                    User.currentUser.resetInfo()
                    
                    // Re-render the LoginView once you completed your loggin out process
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let appController = storyboard.instantiateViewController(withIdentifier: "MainController") as! LoginViewController
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window!.rootViewController = appController
                }
            })
            return false
        }
        return true
    }
    
}
