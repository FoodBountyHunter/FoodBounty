//
//  ItemTableViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit

class ItemTableViewController: PFQueryTableViewController {
    
    var bounty: Bounty!
    var itemsAdded = false
    
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    func configure() {
        self.parseClassName = Item.pClass
        self.pullToRefreshEnabled = false
        self.paginationEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func newItem(designation:String, amount: Int) {
        self.itemsAdded = true
        var newItem = Item(className: Item.pClass)
        newItem.amount = amount
        newItem.designation = designation
        newItem.bounty = bounty
        newItem.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.loadObjects()
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedItem = self.objects![indexPath.row] as! Item
        selectedItem.done = !selectedItem.done
        selectedItem.saveInBackground()
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: Item.pClass)
        if bounty != nil && itemsAdded {
            query.whereKey("bounty", equalTo: bounty)
        }
        
        return query
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if itemsAdded {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        let item = self.objects![indexPath.row] as! Item
        
        cell.textLabel!.text = "\(item.amount)x \(item.designation)"
        cell.accessoryType = item.done ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
        
        return cell
    }
}
