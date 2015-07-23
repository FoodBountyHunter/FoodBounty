//
//  Review.swift
//  FoodBounty
//
//  Created by X Code User on 7/23/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import Foundation

class Review: PFObject, PFSubclassing {
    static let pClass = "Review"
    
    @NSManaged var jobId: Bounty
    @NSManaged var hunterId: PFUser
    @NSManaged var finished: Bool
    @NSManaged var comments: String
    @NSManaged var timeliness: Float
    @NSManaged var qualityRate: Float
    
    static func parseClassName() -> String {
        return pClass
    }
    
    static func queryOpenReviews(forUser user: PFUser) -> PFQuery {
        var query = PFQuery(className: pClass)
        query.whereKey("hunterId", equalTo: user)
        return query
    }
    
    static func createNewReview(forBounty bounty: Bounty) {
        var review = Review(className: pClass)
        review.finished = false
        review.jobId = bounty
        review.hunterId = bounty.hunter
        review.comments = ""
        review.timeliness = 3.0
        review.qualityRate = 3.0
        
        review.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("new review saved")
        }
    }
    
    static func unfinishedReviewCountAsync(forUser user: PFUser, block: (Int) -> Void) {
        var query = Review.getQueryForReviews(forUser: user)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            var count = 0
            for object in objects! {
                let review = object as! Review
                if review.finished == false {
                    count++
                }
            }
            block(count)
        }
    }
    
    static func getQueryForReviews(forUser user: PFUser) -> PFQuery {
        var innerQuery = PFQuery(className: Bounty.pClass)
        innerQuery.whereKey("poster", equalTo: user)
        
        var query = PFQuery(className: Review.pClass)
        query.whereKey("jobId", matchesQuery: innerQuery)
        
        return query
    }
}