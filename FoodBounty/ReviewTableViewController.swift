//
//  ReviewTableViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/23/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit

class ReviewTableViewController: PFQueryTableViewController {
    required init!(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.configure()
    }
    
    func configure() {
        self.parseClassName = Bounty.pClass
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateTable()
    }
    
    func updateTable() {
        self.tableView.beginUpdates()
        self.loadObjects()
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showReviewSegue" {
            var reviewVC = segue.destinationViewController as! ReviewSubmitViewController
            var row: Int = ((self.view as! UITableView).indexPathForSelectedRow())!.row as Int
            reviewVC.review = self.objects![row] as! Review
        }
    }
    
    override func queryForTable() -> PFQuery {
        return Review.getQueryForReviews(forUser: PFUser.currentUser()!)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReviewCell", forIndexPath: indexPath) as! UITableViewCell
        
        let review: Review = self.objects![indexPath.row] as! Review
        let hunter: PFUser = review.hunterId
        let bounty = review.jobId
        
        hunter.fetchInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
            bounty.fetchInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let formatter = NSDateFormatter()
                    formatter.dateStyle = NSDateFormatterStyle.LongStyle
                    formatter.timeStyle = .MediumStyle
                    let dateString = formatter.stringFromDate(bounty.createdAt!)
                    
                    cell.textLabel!.text = hunter.username
                    cell.detailTextLabel!.text = dateString
                })
            }
        }
        
        return cell
    }
}
