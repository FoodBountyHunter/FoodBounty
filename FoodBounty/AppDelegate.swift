//
//  AppDelegate.swift
//  FoodBounty
//
//  Created by X Code User on 7/21/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var count: Int? = 0
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Initializing Parse
        Bounty.registerSubclass()
        Item.registerSubclass()
        Review.registerSubclass()
        
        Parse.setApplicationId("dmiBApXpPQgCeGY2QqNCWkE3DocJRjR1yjfRgTpQ",
            clientKey: "yYOo68JiL6t8dLWOthqlGIkOJOEB1mbT4MKkV1ge")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        GMSServices.provideAPIKey("AIzaSyAIzvJO72_2YJjkDmYsIeiI2RtTKc2AYQQ")
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 1, green: 130/255, blue: 80/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        var shadow = NSShadow()
        shadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        shadow.shadowOffset = CGSizeMake(0, 1)
        var font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 21)
        UINavigationBar.appearance().titleTextAttributes = [NSShadowAttributeName: shadow, NSForegroundColorAttributeName: UIColor.whiteColor()]

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func incrementNetworkActivity()
    {
        self.count!++
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func decrementNetworkActivity()
    {
        if self.count! > 0 {
            self.count!--
        }
        if self.count! == 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    func resetNetworkActivity()
    {
        self.count! = 0
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

}

