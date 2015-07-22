//
//  HomeViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/21/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//


import UIKit
import Parse

class HomeViewController: UIViewController {
    
    @IBOutlet weak var accountSettingsBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        
        self.accountSettingsBarButton.title = PFUser.currentUser()?.username!
    }
    
}