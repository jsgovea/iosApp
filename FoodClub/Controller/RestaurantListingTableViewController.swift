//
//  RestaurantListingTableViewController.swift
//  FoodClub
//
//  Created by Jorge Soto on 11/26/18.
//  Copyright © 2018 Jorge Soto. All rights reserved.
//

import UIKit
import SwiftyJSON

class RestaurantListingTableViewController: UITableViewController {

    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
    var restaurants = [Restaurant]()
    var filteredRestaurants = [Restaurant]()
    
    let activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var searchRestaurant: UISearchBar!
    @IBOutlet var tbRestaurant: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBarButtonItem.target = self.revealViewController()
        menuBarButtonItem.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        loadRestaurants()
    }
    
    func loadRestaurants() {
        
        Helpers.showActivityIndicator(activityIndicator, view)
        
        APIManager.shared.getRestaurants {(json) in
            if json != JSON.null{
                self.restaurants = []
                if let listRes = json["restaurants"].array {
                    for item in listRes {
                        let restaurant = Restaurant(json: item)
                        self.restaurants.append(restaurant)
                    }
                    
                    self.tbRestaurant.reloadData()
                    Helpers.hideActivityIndicator(self.activityIndicator)
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MealList" {
            let controller = segue.destination as! MealsViewController
            controller.restaurant = restaurants[(tbRestaurant.indexPathForSelectedRow?.row)!]
            
        }
    }
    
    func getCategory() {
        
    }
    
}

extension RestaurantListingTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        filteredRestaurants = self.restaurants.filter({ (res: Restaurant) -> Bool in
            return res.name?.lowercased().range(of: searchText.lowercased()) != nil
        })
        
        self.tbRestaurant.reloadData()
    }
}

extension RestaurantListingTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchRestaurant.text != "" {
            return self.filteredRestaurants.count
        }
        return self.restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        
        let restaurant: Restaurant
        
        if searchRestaurant.text != "" {
            restaurant = filteredRestaurants[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        
        cell.restaurantName.text =  restaurant.name!
        cell.restaurantAddress.text = restaurant.address!
        
        
        if let logoName = restaurant.logo {
            Helpers.loadImage(cell.restaurantLogo, "\(logoName)")
        }
        
//        cell.restaurantCategory.text =  restaurant.category!
        
     
        return cell
        
    }
}
