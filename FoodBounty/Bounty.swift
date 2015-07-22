//
//  Bounty.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import Foundation
import Parse

class Bounty: PFObject {
    static let pClass = "Bounty"
    
    override init() {
        super.init()
    }
    
    override init(className newClassName: String) {
        super.init(className: newClassName)
        self.category = 0
        self.comment = ""
        self.reward = 0
    }
    
    var category: Int {
        get {
            return self.objectForKey("category") as! Int
        }
        set(newValue) {
            self.setObject(newValue, forKey: "category")
        }
    }
    
    var comment: String {
        get {
            return self.objectForKey("comment") as! String
        }
        set(newValue) {
            self.setObject(newValue, forKey: "comment")
        }
    }
    
    var reward: Float {
        get {
            return self.objectForKey("reward") as! Float
        }
        set(newValue) {
            self.setObject(newValue, forKey: "reward")
        }
    }
    
    var poster: PFUser {
        get {
            return self.objectForKey("poster") as! PFUser
        }
        set(newValue) {
            self.setObject(newValue, forKey: "poster")
        }
    }
    
    var hunter: PFUser {
        get {
            return self.objectForKey("hunter") as! PFUser
        }
        set(newValue) {
            self.setObject(newValue, forKey: "hunter")
        }
    }
    
    var status: Int {
        get {
            return self.objectForKey("status") as! Int
        }
        set(newValue) {
            self.setObject(newValue, forKey: "status")
        }
    }
}