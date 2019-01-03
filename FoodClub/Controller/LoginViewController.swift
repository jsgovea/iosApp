//
//  LoginViewController.swift
//  FoodClub
//
//  Created by Jorge Soto on 12/11/18.
//  Copyright © 2018 Jorge Soto. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    var fbLoginSuccess = false
    var userType: String = USERTYPE_CUSTOMER
    
    
    
    @IBOutlet weak var bLogin: UIButton!
    @IBOutlet weak var bLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bLogout.isHidden = true
        
        if(FBSDKAccessToken.current() != nil)
        {
            bLogout.isHidden = true
            FBManager.getFBUserData(completionHandler: {
                self.bLogin.setTitle("Continuar como \(User.currentUser.name!)", for: .normal)
                
            })
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        fbLoginSuccess = FBSDKAccessToken.current() != nil
        if fbLoginSuccess {
            performSegue(withIdentifier: "CustomerView", sender: nil)

        }
        
//        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true)
//        {
//            performSegue(withIdentifier: "CustomerView", sender: nil)
//        }
        
    }
    
    @IBAction func facebookLogout(_ sender: Any) {
        
        APIManager.shared.logout { (error) in
            if error == nil
            {
                
                FBManager.shared.logOut()
                User.currentUser.resetInfo()
                
                self.bLogout.isHidden = true
            }
        }
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        
        if(FBSDKAccessToken.current() != nil)
        {
            APIManager.shared.login(userType: userType, completionHandler:  { (error) in
                if error == nil
                {
                 
                    self.fbLoginSuccess = true
                    self.viewDidAppear(true)
                }
            })
            
        } else {
            
            FBManager.shared.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
                
                if(error == nil )
                {
                    FBManager.getFBUserData(completionHandler: {
                        APIManager.shared.login(userType: self.userType, completionHandler:  { (error) in
                            if error == nil
                            {
                                
                                self.fbLoginSuccess = true
                                self.viewDidAppear(true)
                            }
                        })
                    })
                    
                }
            }
        }
    }
    
  

}
