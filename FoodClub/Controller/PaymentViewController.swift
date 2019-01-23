//
//  PaymentViewController.swift
//  FoodClub
//
//  Created by Jorge Soto on 1/6/19.
//  Copyright © 2019 Jorge Soto. All rights reserved.
//

import UIKit
import Stripe

class PaymentViewController: UIViewController {

    @IBOutlet weak var paymentTextField: STPPaymentCardTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func placerOrder(_ sender: Any) {
        APIManager.shared.getLatestOrder { (json) in
            if json["order"]["status"] == nil || json["order"]["status"] == "Entregado" {
                let card = self.paymentTextField.cardParams
                
                STPAPIClient.shared().createToken(withCard: card, completion: { (token, error) in
                    if let myError = error {
                        print("Error", myError)
                    } else if let stripeToken = token {
                        APIManager.shared.createOrder(stripeToken: stripeToken.tokenId) { (json) in
                            Tray.currentTray.reset()
                            self.performSegue(withIdentifier: "ViewOrder", sender: self)
                        }
                    }
                })
                
            } else {
                let cancelAction = UIAlertAction(title: "OK", style: .cancel)
                let okAction = UIAlertAction(title: "Ir a la orden", style: .default, handler: { (action) in
                    self.performSegue(withIdentifier: "ViewOrder", sender: self)
                })
                
                let alertView = UIAlertController(title: "¿Comleto su orden?", message: "Su orden no esta completa", preferredStyle: .alert)
                
                alertView.addAction(cancelAction)
                
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
    

}
