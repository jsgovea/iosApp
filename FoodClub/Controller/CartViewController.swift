//
//  CartViewController.swift
//  FoodClub
//
//  Created by Jorge Soto on 12/11/18.
//  Copyright © 2018 Jorge Soto. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class CartViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!

    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewTotal: UIView!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var addPayment: UIButton!
    
    @IBOutlet weak var lbTotal: UILabel!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        addressTextField.delegate = self
        
        menuBarButtonItem.target = self.revealViewController()
        menuBarButtonItem.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        if Tray.currentTray.items.count == 0 {
            // If is empty show message
            let emptyTray = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
            
            emptyTray.center = self.view.center
            emptyTray.textAlignment = NSTextAlignment.center
            emptyTray.text = "Orden vacía, por favor seleccione un platillo"
            emptyTray.numberOfLines = 2
            
            self.view.addSubview(emptyTray)
            
        } else {
            // Display all of the UI controllers
            
            self.separatorView.isHidden = false
            self.tableView.isHidden = false
            self.viewTotal.isHidden = false
            self.viewAddress.isHidden = false
            self.addressTextField.isHidden = false
            self.addPayment.isHidden = false
            self.map.isHidden = false
            
            loadMeals()
        }
        getCurrentLocation()
        
    }
    
    func loadMeals() {
        self.tableView.reloadData()
        self.lbTotal.text = "$\(Tray.currentTray.getTotal())"
        
    }
    
    func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            Tray.currentTray.address = "\(String(describing: locationManager))"
            self.map.showsUserLocation = true
        }
        
    }
    
    
    @IBAction func addPayment(_ sender: Any) {
//        if self.addressTextField.text == "" {

//            let alertController = UIAlertController(title: "Opps!", message: "Debes agregar tu dirección", preferredStyle: .alert)

//            let action = UIAlertAction(title: "Ok!", style: .default) { (alert) in
//                self.addressTextField.becomeFirstResponder()
//            }
        
//            alertController.addAction(action)
//            self.present(alertController, animated: true, completion: nil)

//        } else {
//            Tray.currentTray.address = addressTextField.text
            self.performSegue(withIdentifier: "AddPayment", sender: self)
//        }
    }
}

extension CartViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Tray.currentTray.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardItemCell", for: indexPath) as! TrayViewCell
        let tray = Tray.currentTray.items[indexPath.row]
        cell.quantityLabel.text = "\(tray.quantity)"
        cell.mealName.text = tray.meal.name
        cell.subTotal.text = "\(tray.meal.price! * Float(tray.quantity))"
        
        return cell
    }
    
    
}


extension CartViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as! CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(0.01, 0.01))
        
        self.map.setRegion(region, animated: true)
    }
}

extension CartViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let address = textField.text
        let geocoder = CLGeocoder()
//        Tray.currentTray.address = address
        
        geocoder.geocodeAddressString(address!) { (placemarks, error) in
            if error != nil {
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinate = placemark.location!.coordinate
                let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
                self.map.setRegion(region, animated: true)
                self.locationManager.stopUpdatingLocation()
                
                let pin = MKPointAnnotation()
                pin.coordinate = coordinate
                self.map.addAnnotation(pin)
                
            }
        }
        
        return true
    }
}
