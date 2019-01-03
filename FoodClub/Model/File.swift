//
//  File.swift
//  FoodClub
//
//  Created by Jorge Soto on 12/30/18.
//  Copyright © 2018 Jorge Soto. All rights reserved.
//

import Foundation


class TrayItem {
    var meal: Meal
    var quantity: Int
    var extras: String
    
    init(meal: Meal, quantity: Int, extras: String) {
        self.meal = meal
        self.quantity = quantity
        self.extras = extras
    }
}

class Tray {
    static let currentTray = Tray()
    
    var restaurant: Restaurant?
    var items = [TrayItem]()
    var address: String?
    
    func getTotalQuantity() -> Int {
        var total = 0
        for item in items {
            total += item.quantity
        }
        return total
    }
    
    func getTotal() -> Float {
        var total: Float = 0
        
        for item in self.items {
            total = total + Float(item.quantity) * item.meal.price!
        }
        return total
    }
    
    func reset() {
        self.restaurant = nil
        self.items = []
        self.address = nil
    }
}
