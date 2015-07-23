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
    
    class func statusColorById(id: Int) -> UIColor {
        switch id {
        case 3:
            return UIColor.lightGrayColor()
        case 4:
            return UIColor(red: (220/255), green: (20/255), blue: 0, alpha: 1)
        default:
            return UIColor(red: (129/255), green: (222/255), blue: 18/255, alpha: 1)
        }
    }
}