//
//  MealsViewController.swift
//  FoodClub
//
//  Created by Jorge Soto on 11/28/18.
//  Copyright © 2018 Jorge Soto. All rights reserved.
//

import UIKit

class MealsViewController: UITableViewController
{
    
    var restaurant: Restaurant?
    var meals = [Meal]()
    
    @IBOutlet weak var restaurantImage: UIImageView!
    
    let activityIndicator = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 140.0
//        title = "Platillos "
        
        if let restaurantName = restaurant?.name {
            self.navigationItem.title = restaurantName
        }
        
        if let logoName = restaurant?.logo {
            Helpers.loadImage(restaurantImage, "\(logoName)")
        }
        
        loadMeals()

    }
    
    @IBAction func goToRestaurant(_ sender: Any) {
//    performSegue(withIdentifier: "map", sender: nil)
    }
    
    
    
    func loadMeals() {
        
        Helpers.showActivityIndicator(activityIndicator, view)
        
        if let restaurantId = restaurant?.id {
            
            APIManager.shared.getMeals(restaurantId: restaurantId) { (json) in
                
                
                if json != nil {
                    self.meals = []
                    
                    if let tempMeals = json["meals"].array {
                        for item in tempMeals {
                            let meal = Meal(json: item)
                            self.meals.append(meal)
                        }
                        self.tableView.reloadData()
                        Helpers.hideActivityIndicator(self.activityIndicator)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MealDetails" {
            
            let controller = segue.destination as! MealDetailViewController
            
            controller.meal = meals[(tableView.indexPathForSelectedRow?.row)!]
            controller.restaurant = restaurant
        }
    }

}


// MARK: - UITableViewDataSource

extension MealsViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealViewCell
        
        let meal = meals[indexPath.row]
        cell.mealName.text = meal.name
        cell.mealDescription.text = meal.description
        
        
        if let time = meal.cook_time {
            cell.time.text = "\(time)"
        }
        
        if let price = meal.price {
            cell.price.text = "\(price)"
        }
        
        if let image = meal.image {
            Helpers.loadImage(cell.mealImage, "\(image)")
        }
        
        return cell
    }
    
    
}












