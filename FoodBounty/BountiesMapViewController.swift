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
        
        var camera = GMSCameraPosition.cameraWithLatitude(47.498995, longitude: 8.728665, zoom: 5)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.settings.compassButton = false
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        self.view = mapView
        
        Bounty.getQuery(notPostedByUser: PFUser.currentUser()!).findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if objects != nil {
                for bounty in objects! {
                    let poster = bounty.objectForKey("poster") as! PFUser
                    poster.fetch()
                    var address = AdressHelper.getReadableAdress(poster)
                    self.placeBountyMarker(address, bounty: (bounty as! Bounty))
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
        marker.title = "\(reward)$"
        marker.snippet  = BountyCategory.categoryById(bounty.category)
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.userData = bounty
        marker.map = self.view as! GMSMapView
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        
    }
    
    func mapView(mapView: GMSMapView!, markerInfoWindow marker: GMSMarker!) -> UIView! {
        
        return nil
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
            }
        } else {
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateLocation(true)
    }
}
