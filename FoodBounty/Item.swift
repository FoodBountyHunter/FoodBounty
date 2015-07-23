//
//  Item.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import Foundation

class Item: PFObject, PFSubclassing {
    static let pClass = "Item"
    
    @NSManaged var amount: Int
    @NSManaged var designation: String
    @NSManaged var done: Bool
    @NSManaged var bounty: Bounty
    
    static func parseClassName() -> String {
        return pClass
    }    
}