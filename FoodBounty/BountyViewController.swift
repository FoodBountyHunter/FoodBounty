//
//  BountyViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit

class BountyViewController: UIViewController {
    
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UITextView!
    @IBOutlet weak var actionButton: UIButton!
    
    var itemTableViewController: ItemTableViewController!
    
    var bounty: Bounty!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
    }
    
    func initData() {
        self.rewardLabel.text = "\(self.bounty.reward)$"
        self.categoryLabel.text = BountyCategory.categoryById(self.bounty.category)
        self.usernameLabel.text = self.bounty.poster.username
        self.commentLabel.text = self.bounty.comment
        self.statusLabel.text = BountyStatus.statusById(self.bounty.status)
        if bounty.status == 4 {
            self.statusLabel.textColor = UIColor(red: (220/255), green: (20/255), blue: 0, alpha: 1)
        }
        else if bounty.status == 3 {
            self.statusLabel.textColor = UIColor.lightGrayColor()
        }
        
        if PFUser.currentUser()?.objectId == bounty.poster.objectId {
            if bounty.status == 0 {
                self.actionButton.setTitle("Cancel", forState: .Normal)
                self.actionButton.backgroundColor = UIColor(red: (220/255), green: (20/255), blue: 0, alpha: 1)
                self.actionButton.hidden = false
            }
            else {
                self.actionButton.hidden = true
            }
        }
        else {
            if bounty.status == 0 {
                self.actionButton.setTitle("Claim", forState: .Normal)
                self.actionButton.hidden = false
            } else if bounty.status == 1 {
                self.actionButton.setTitle("Deliver", forState: .Normal)
                self.actionButton.hidden = false
            } else if bounty.status == 2 {
                self.itemTableViewController.itemsCheckable = true
                self.actionButton.setTitle("Finish", forState: .Normal)
                self.actionButton.hidden = false
            } else {
                self.itemTableViewController.itemsCheckable = false
                self.actionButton.hidden = true
            }
        }
    }
    
    @IBAction func statusAction(sender: AnyObject) {
        if PFUser.currentUser()?.objectId == bounty.poster.objectId {
            if bounty.status == 0 {
                self.bounty.status = 4
            }
        }
        else {
            if bounty.status == 0{
                self.bounty.status = 1
                self.bounty.hunter = PFUser.currentUser()!
            }
            else if bounty.status == 1 {
                self.bounty.status = 2
            }
            else if bounty.status == 2 {
                if itemTableViewController.allItemsChecked() {
                    self.bounty.status = 3
                }
                else {
                    var alert = UIAlertController(title: "Wait!", message: "You have to check all items before you can deliver them.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        
        bounty.save()
        self.initData()
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "itemTableViewEmbed" {
            self.itemTableViewController = segue.destinationViewController as! ItemTableViewController
            self.itemTableViewController.bounty = self.bounty
            self.itemTableViewController.itemsAdded = true
        }
    }
}
