//
//  BountiesMapViewController.swift
//  FoodBounty
//
//  Created by X Code User on 7/22/15.
//  Copyright (c) 2015 gvsu.edu.team_c. All rights reserved.
//

import Foundation

class BountiesMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        var camera = GMSCameraPosition.cameraWithLatitude(42.96356, longitude: -85.8899, zoom: 14.7)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        mapView.delegate = self
        //mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        self.view = mapView
        
        var query = Bounty.claimableBountiesQuery(PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if objects != nil {
                for bounty in objects! {
                    let poster = bounty.objectForKey("poster") as! PFUser
                    poster.fetchInBackgroundWithBlock { (object: PFObject?, error: NSError?) -> Void in
                        var address = AdressHelper.getReadableAdress(poster)
                        self.placeBountyMarker(address, bounty: (bounty as! Bounty))
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        //var mapView = self.view as! GMSMapView
        //mapView.removeObserver(self, forKeyPath: "myLocation")
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "myLocation" {
            if let mapView = self.view as? GMSMapView {
                if mapView.myLocation != nil {
                    var camera = GMSCameraPosition.cameraWithTarget(mapView.myLocation.coordinate, zoom: 16.0)
                    mapView.animateToCameraPosition(camera)
                }
            }
        }
    }
    
    func placeBountyMarker(address: String, bounty: Bounty){
        var addressStr = address.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let url = NSURL(string: "http://maps.google.com/maps/api/geocode/json?address=\(addressStr)&sensor=false")
        let session = NSURLSession.sharedSession()
        var parseError: NSError?
        let task = session.downloadTaskWithURL(url!) {
            (loc: NSURL!, response:NSURLResponse!, error:NSError!) -> Void in
            let d = NSData(contentsOfURL: loc)!
            let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments, error: &parseError)
            if let topLevelObject = parsedObject as? NSDictionary {
                if let results = topLevelObject.objectForKey("results") as? NSArray {
                    if let geometry = results[0].objectForKey("geometry") as? NSDictionary {
                        if let location = geometry.objectForKey("location") as? NSDictionary {
                            let lat: Double = location.objectForKey("lat") as! Double
                            let lng: Double = location.objectForKey("lng") as! Double
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.createBountyMarker(lat, lng: lng, bounty: bounty)
                            }
                        }
                    }
                }
            }
        }
        (UIApplication.sharedApplication().delegate as! AppDelegate).incrementNetworkActivity()
        task.resume()
    }
    
    func createBountyMarker(lat: Double, lng: Double, bounty: Bounty) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, lng)
        let reward = bounty.reward
        marker.title = "\(BountyCategory.categoryById(bounty.category)), \(reward) $"
//        marker.snippet  = "\(bounty.itemCount()) Items"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.userData = bounty
        marker.map = self.view as! GMSMapView
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        self.performSegueWithIdentifier("displayBountyFromMapSegue", sender: self)
        var bountyVC = self.navigationController?.visibleViewController as! BountyViewController
        bountyVC.bounty = marker.userData as! Bounty
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        updateLocation(false)
        updateLocation(true)
    }
    
    func updateLocation(running: Bool) {
        let mapView = self.view as! GMSMapView
        let status = CLLocationManager.authorizationStatus()
        if running {
            if (CLAuthorizationStatus.AuthorizedWhenInUse == status) {
                locationManager.startUpdatingLocation()
                mapView.myLocationEnabled = true
                mapView.settings.myLocationButton = true
            }
        } else {
            locationManager.stopUpdatingLocation()
            mapView.settings.myLocationButton = false
            mapView.myLocationEnabled = false
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateLocation(true)
        //var mapView = self.view as! GMSMapView
        //mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
    }
}
