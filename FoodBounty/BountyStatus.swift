//
//  BountyStatus.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import Foundation

class BountyStatus {
    static let stati = [0: "Open", 1: "Claimed", 2: "Delivering", 3: "Finished", 4: "Cancelled"]
    
    class func statusById(id: Int) -> String {
        return BountyStatus.stati[id]!
    }
}