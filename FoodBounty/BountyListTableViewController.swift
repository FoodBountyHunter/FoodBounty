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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.beginUpdates()
        self.loadObjects()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    func openMapView () {
        self.performSegueWithIdentifier("showMapViewSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "displayBountyFromListSegue" {
            var bountyVC = segue.destinationViewController as! BountyViewController
            var row: Int = ((self.view as! UITableView).indexPathForSelectedRow())!.row as Int
            bountyVC.bounty = self.objects![row] as! Bounty
        }
    }
    
    override func queryForTable() -> PFQuery {
        return Bounty.claimableBountiesQuery(PFUser.currentUser()!)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BountyCell", forIndexPath: indexPath) as! BountyListTableViewCell
        let bounty: Bounty = self.objects![indexPath.row] as! Bounty
        let poster = bounty.poster
        poster.fetch()
        
        cell.rewardLabel.text = "\(bounty.reward)$"
        cell.itemsCountLabel.text = "\(bounty.itemCount()) Items"
        cell.categoryLabel.text = BountyCategory.categoryById(bounty.category)
        cell.addressLabel.text = AdressHelper.getReadableAdress(poster)
        
        return cell
    }
}