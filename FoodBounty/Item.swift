//
//  Item.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import Foundation

class Item: PFObject {
    static let pClass = "Item"
 
    var amount: Int {
        get {
            return self.objectForKey("amount") as! Int
        }
        set(newValue) {
            self.setObject(newValue as Int, forKey: "amount")
        }
    }
    var designation: String {
        get {
            return self.objectForKey("designation") as! String
        }
        set(newValue) {
            self.setObject(newValue, forKey: "designation")
        }
    }
    
}