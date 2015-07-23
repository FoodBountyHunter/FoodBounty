//
//  BountyListTableViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit

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
        
        let mapButton = UIBarButtonItem(title: "View on map", style: UIBarButtonItemStyle.Plain, target: self, action: "openMapView")
        self.navigationItem.rightBarButtonItem = mapButton
    }
    
    func openMapView () {
        self.performSegueWithIdentifier("showMapViewSegue", sender: self)
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
        poster.fetch()
        
        cell.textLabel!.text = "\(reward)$"
        cell.detailTextLabel!.text = AdressHelper.getReadableAdress(poster)
        
        return cell
    }
}