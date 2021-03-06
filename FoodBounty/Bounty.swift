//
//  Bounty.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import Foundation

class Bounty: PFObject, PFSubclassing {
    static let pClass = "Bounty"
    
    @NSManaged var category: Int
    @NSManaged var comment: String
    @NSManaged var reward: Float
    @NSManaged var poster: PFUser
    @NSManaged var hunter: PFUser
    @NSManaged var status: Int
    
    class func claimableBountiesQuery(user: PFUser) -> PFQuery {
        var query = PFQuery(className: pClass)
        query.whereKey("poster", notEqualTo: user)
        query.whereKey("status", equalTo: 0)
        return query
    }
    
    class func postedBountiesQuery(user: PFUser) -> PFQuery {
        var query = PFQuery(className: pClass)
        query.whereKey("poster", equalTo: user)
        return query
    }
    
    class func claimedBountiesQuery(user: PFUser) -> PFQuery {
        var query = PFQuery(className: pClass)
        query.whereKey("hunter", equalTo: user)
        return query
    }
    
    static func parseClassName() -> String {
        return pClass
    }
    
    func itemCountAsync(block: (Int) -> Void) {
        var query = PFQuery(className: Item.pClass)
        query.whereKey("bounty", equalTo: self)
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            var count = 0
            for object in objects! {
                let item = object as! Item
                count += item.amount
            }
            block(count)
        }
    }
}