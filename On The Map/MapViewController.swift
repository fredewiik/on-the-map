//
//  MapViewController.swift
//  On The Map
//
//  Created by Frédéric Lépy on 04/05/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        //Set the buttons in the Navbar
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh:")
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "postInformation")
        self.navigationItem.setRightBarButtonItems([refreshButton, pinButton], animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.loadUsersData()
    }
    
    
    func loadUsersData() {
        
        ParseAPI.getStudentLocations(100) { (success, error, results) in
            if success {
                
                //save the data and display the new ones
                AppDelegate.users = results!["results"] as? [[String:AnyObject]]
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.displayUsersLocations()
                })
                
            } else {
                dispatch_async(dispatch_get_main_queue(), {self.displayError(error!)})
            }
        }
    }
    
    
    func displayError(error: NSError) {
        let alertController = UIAlertController(title: "Connection failed", message: error.description, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: { (action) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func displayUsersLocations() {

        var annotations = [OTMAnnotation]()
        var location = CLLocationCoordinate2D()
        var fullNameString = String()
        var urlString = String()
        
        for user in AppDelegate.users! {
            
            location.latitude = user["latitude"] as? CLLocationDegrees ?? CLLocationDegrees()
            location.longitude = user["longitude"] as? CLLocationDegrees ?? CLLocationDegrees()
            
            let firstname = user["firstName"] as? String ?? String()
            let lastname = user["lastName"] as? String ?? String()
            fullNameString = firstname + " " + lastname
            
            urlString = user["mediaURL"] as? String ?? String()
            
            let annotation = OTMAnnotation(position: location, title: fullNameString, subtitle: urlString)
            
            annotations.append(annotation)
        }

        self.mapView.addAnnotations(annotations)
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if let view = self.mapView.dequeueReusableAnnotationViewWithIdentifier("pin") {
            
            //println("has reused a pin")
            return view
            
        } else {

            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")

            view.pinColor = MKPinAnnotationColor.Red
            view.enabled = true
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIView
            
            return view
        }
    }
    
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        let annotation = view.annotation as! OTMAnnotation
        let urlString = annotation.subtitle
        self.performSegueWithIdentifier("towardStudentURL2", sender: urlString)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "towardStudentURL2" {
            
            let webView = segue.destinationViewController as! WebViewController
            webView.urlString = sender as? String
        }
    }
    
    
    func refresh(sender: AnyObject) {
        self.loadUsersData()
    }
    
    func postInformation() {
        performSegueWithIdentifier("towardInformationPost", sender: self)
    }

}
