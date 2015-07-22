//
//  BountyListTableViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BountyListTableViewController: PFQueryTableViewController {
    
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    func configure() {
        self.parseClassName = Bounty.pClass
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: Bounty.pClass)
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let bounty: PFObject = self.objects![indexPath.row] as! PFObject
        let reward = bounty.objectForKey("reward") as! Int
        let poster = bounty.objectForKey("poster") as! PFUser
        bounty.fetchIfNeededInBackgroundWithBlock {
            (bounty: PFObject?, error: NSError?) -> Void in
            let poster = bounty?["poster"] as? PFUser
            dispatch_async(dispatch_get_main_queue()) {
                cell.detailTextLabel!.text = AdressHelper.getReadableAdress(poster!)
            }
        }
        
        poster.fetch()
        
        /*var query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: poster)
        query.findObjectsInBackgroundWithBlock({(result:[AnyObject]?, error:NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    cell.detailTextLabel!.text = AdressHelper.getReadableAdress(result[0] as! PFUser)
                }
        })*//*
        print(poster)
        print(poster.description)
        var posterStr = poster.description
        // set up the query on the Follow table
        let query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: poster.description)
        
        // execute the query
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if let objects = objects {
                for o in objects {
                    // o is an entry in the Follow table
                    // to get the user, we get the object with the to key
                    let otherUse = o.objectForKey("to") as? PFUser
                    
                    // to get the time when we followed this user, get the date key
                    let when = o.objectForKey("date") as? PFObject
                }
            }
        }*/
        
        cell.textLabel!.text = "\(reward)$"
        cell.detailTextLabel!.text = AdressHelper.getReadableAdress(poster)
        
        return cell
    }
}