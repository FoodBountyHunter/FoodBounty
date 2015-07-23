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
    
    var itemTableViewController: ItemTableViewController!
    
    var bounty: Bounty!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initData() {
        self.rewardLabel.text = "\(self.bounty.reward)$"
        self.categoryLabel.text = BountyCategory.categoryById(self.bounty.category)
        self.statusLabel.text = "\(self.bounty.status)"
        self.usernameLabel.text = self.bounty.poster.username
        self.commentLabel.text = self.bounty.comment
    }
    
    @IBAction func statusAction(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "itemTableViewEmbed" {
            self.itemTableViewController = segue.destinationViewController as! ItemTableViewController
            self.itemTableViewController.bounty = self.bounty
        }
    }
}
