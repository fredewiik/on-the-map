//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Frédéric Lépy on 17/05/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InformationPostingViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var FindButton: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var prompt: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var location: CLLocationCoordinate2D?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Set the render attributes for the buttons
        FindButton.layer.backgroundColor = UIColor.whiteColor().CGColor
        FindButton.layer.borderColor = UIColor.whiteColor().CGColor
        SubmitButton.layer.backgroundColor = UIColor.whiteColor().CGColor
        SubmitButton.layer.borderColor = UIColor.whiteColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    

    @IBAction func FindOnTheMap(sender: AnyObject) {
        
        //start activity indicator
        self.activityIndicator.startAnimating()
        
        //Geocode from address textfield
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressTextField.text, completionHandler: { (placemarks:[AnyObject]!, error:NSError!) -> Void in
            
            if let placemark = placemarks?[0] as? CLPlacemark {
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
                
                //Center the map on the placemark
                let location = placemark.location.coordinate
                let region = MKCoordinateRegionMakeWithDistance(location, 500, 500)
                self.mapView.setRegion(region, animated: true)
                
                //Save the location
                self.location = location
                
                //Hide prompt + textField + Find button
                self.FindButton.hidden = true
                self.addressTextField.hidden = true
                self.prompt.hidden = true
                
                //show the map + submit button + url textfield
                self.mapView.hidden = false
                self.SubmitButton.hidden = false
                self.urlTextField.hidden = false
                
            } else {
                self.displayError(error)
            }
            //stop activity indicator
            dispatch_async(dispatch_get_main_queue(), {self.activityIndicator.stopAnimating()})
        })
    }
    
    @IBAction func Submit(sender: AnyObject) {
        
        //If no url entered, display error
        if urlTextField.text == "" {
            let error = NSError(domain: "Please enter an valid url", code: 13, userInfo: nil)
            displayError(error)
            return
        }
        
        let url = NSURL(string: urlTextField.text)
        
        //Check whether the url is valid
        let isURLValid: Bool = checkURLValidity(url)
        
        //If url is invalid handle error
        if !isURLValid {
            let error = NSError(domain: "Invalid URL", code: 12, userInfo: nil)
            displayError(error)
            return
        } else {
        
        //Send the data to the server and handle error
        ParseAPI.postStudentLocation(addressTextField.text, url: url!, latitude: location!.latitude, longitude: location!.longitude) { (success, error) -> Void in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.displayError(error!)
            }
        }}
    }
    
    func checkURLValidity(url: NSURL?) -> Bool {
        
        var isValidURL: Bool = true
        let request = NSURLRequest(URL: url!)
        
        //URL isn't nil
        if url != nil {
            
            //URL has a scheme
            if let scheme = (url!.scheme?.isEmpty) {
                isValidURL = false
            }
            //URL has a host
            if let host = url!.host?.isEmpty {
                isValidURL = false
            }
            
            //URL is reachable
            isValidURL = NSURLConnection.canHandleRequest(request)
        
        } else {
            isValidURL = false
        }
        
        print("url is:  \(isValidURL) \n")
        return isValidURL
    }
    
    func displayError(error: NSError) {
        let alertController = UIAlertController(title: "Error", message: error.description, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: { (action) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
