//
//  AdressHelper.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import Foundation

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
        
        let streetStr = street == nil ? "" : street!
        let postalCodeStr = postalCode == nil ? "" : postalCode!
        let cityStr = city == nil ? "" : city!
        let stateStr = state == nil ? "" : AdressHelper.getState(forId: state!)
        
        return "\(streetStr), \(postalCodeStr), \(cityStr), \(stateStr)"
    }
}