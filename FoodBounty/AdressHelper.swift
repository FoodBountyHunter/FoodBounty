//
//  AdressHelper.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import Foundation
import Parse

class AdressHelper {
    
    static var states:[String]? = nil
    
    class func getState(forId id: Int) -> String {
        return getAllStates()[id]
    }
    
    class func getAllStates() -> [String] {
        if states == nil {
            var filePath = NSBundle.mainBundle().pathForResource("states", ofType: "json")
            var data = NSData(contentsOfFile: filePath!)
            var parseError: NSError?
            let parsedObject = Optional(NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: &parseError))
            AdressHelper.states = []
            if let topLevelObj = parsedObject as? NSArray {
                for state in topLevelObj {
                    states!.append(state as! String)
                }
            }
        }
        
        return AdressHelper.states!
    }
    
    class func getReadableAdress(user: PFUser) -> String {
        let street = user.objectForKey("street") as? String
        let postalCode = user.objectForKey("postalCode") as? String
        let city = user.objectForKey("city") as? String
        let state = user.objectForKey("state") as? Int
        
        return "\(street!), \(postalCode!), \(city!), \(AdressHelper.getState(forId: state!))"
    }
}