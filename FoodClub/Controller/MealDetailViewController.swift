//
//  MealDetailViewController.swift
//  FoodClub
//
//  Created by Jorge Soto on 11/29/18.
//  Copyright © 2018 Jorge Soto. All rights reserved.
//

import UIKit

class MealDetailViewController : UIViewController
{
    
    @IBOutlet weak var quantityButtonsContainerView: UIView!
    
    @IBOutlet weak var lbQuantity: UILabel!
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealDescription: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealExtras: UITextField!
    
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var cardButton: UIBarButtonItem! {
        didSet {
            let icon = UIImage(named: "icon_cart")
            let iconSize = CGRect(origin: CGPoint.zero, size: icon!.size)
            let iconButton = UIButton(frame: iconSize)
            iconButton.setBackgroundImage(icon, for: .normal)
            self.cardButton.customView = iconButton
            if Tray.currentTray.items.count != 0 {
                self.updateCartBarButtonItem()
            }
            
        }
    }
    
    var meal: Meal?
    var restaurant: Restaurant?
    var quantity = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = cardButton

        
        
        loadMeal()
    }
    
    
    @IBAction func actionButton(_ sender: Any) {
        performSegue(withIdentifier: "ActionButton", sender: nil)
        print("Hola")
    }
    
    func loadMeal() {
        
        if let price = meal?.price {
            total.text = "$\(price)"
        }
        
        mealName.text = meal?.name
        mealDescription.text = meal?.description
        
        if let imageUrl = meal?.image {
            Helpers.loadImage(mealImage, "\(imageUrl)")
        }
    }
    
    
    @IBAction func addToTray(_ sender: Any) {
        
        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        image.image = UIImage(named: "button_chicken")
        image.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - 100)
        self.view.addSubview(image)
        startAnimatingCardButton()

        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {image.center = CGPoint(x: self.view.frame.width - 40, y: 24 )}, completion: {_ in image.removeFromSuperview()
            
            let trayItem = TrayItem(meal: self.meal!, quantity: self.quantity, extras: self.mealExtras.text!)
            
            guard let trayRestaurant = Tray.currentTray.restaurant, let currentRestaurant = self.restaurant else {
                // New cart
                Tray.currentTray.restaurant = self.restaurant
                Tray.currentTray.items.append(trayItem)

                return
            }
            

            
            
            
            // else, if the ordered meals are from the same restaurant
            if trayRestaurant.id == currentRestaurant.id {
                // check if the meal item is already on the card
                let inTray = Tray.currentTray.items.index(where: { (item) -> Bool in
                    return item.meal.id! == trayItem.meal.id!
                })
                
                if let index = inTray {
                    
                    let alertView = UIAlertController(title: "¿Desea añadir más?", message: "Tu orden ya incluye este platillo. ¿Quieres añadir de todos modos?", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Agregar", style: .default, handler: { (action: UIAlertAction!) in
                        
                        Tray.currentTray.items[index].quantity += self.quantity
                        self.startAnimatingCardButton()
                    })
                    
                    let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                    
                    alertView.addAction(okAction)
                    alertView.addAction(cancelAction)
                    
                    self.present(alertView, animated: true, completion: nil)
                    
                } else {
                    
                    Tray.currentTray.items.append(trayItem)
                    self.startAnimatingCardButton()
                    
                }
                
            } else {
                // ordered from another restaurant
                let alertView = UIAlertController(title: "¿Deseas iniciar nuevo pedido?", message: "Estas ordenando de un restaurante diferente. Se eliminará tu orden anterior", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Nueva Orden", style: .default, handler: { (action: UIAlertAction!) in
                    
                    Tray.currentTray.items = []
                    Tray.currentTray.items.append(trayItem)
                    Tray.currentTray.restaurant = self.restaurant
                    self.startAnimatingCardButton()
                 })
                
                let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                
                alertView.addAction(okAction)
                alertView.addAction(cancelAction)
                
                self.present(alertView, animated: true, completion: nil)
            }
            self.updateCartBarButtonItem()
        })
        
    }
    
    func startAnimatingCardButton() {
        cardButton.tintColor = UIColor(red: 89 / 255.0, green: 189 / 255.0, blue: 90 / 255.0, alpha: 1)
        cardButton.customView?.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        cardButton.customView?.tintColor = UIColor(red: 89 / 255.0, green: 189 / 255.0, blue: 90 / 255.0, alpha: 1)
        
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .curveLinear,  animations:
            {

                self.cardButton.customView?.transform = .identity

        } ) {(complete) in
            self.updateCartBarButtonItem()
        }
    }
    
    func updateCartBarButtonItem() {
        self.cardButton.addBadge(number: Tray.currentTray.getTotalQuantity())

    }
    
    @IBAction func addQuantity(_ sender: Any) {
        if quantity < 99 {
            quantity += 1
            lbQuantity.text = String(quantity)
            
            if let price = meal?.price {
                total.text = "$\(price * Float(quantity))"
            }
        }
    }
    
    @IBAction func removeQuantity(_ sender: Any) {
        
        if quantity >= 2 {
            quantity -= 1
            lbQuantity.text = String(quantity)
            
            if let price = meal?.price {
                total.text = "$\(price * Float(quantity))"
            }
        }
    }
}

 extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }

}

private var handle: UInt8 = 0;

 extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }

    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }

        badgeLayer?.removeFromSuperlayer()

        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(7)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)

        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = kCAAlignmentCenter
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: offset.y), size: CGSize(width: 8, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)

        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }

    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}




