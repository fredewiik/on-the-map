//
//  ListViewController.swift
//  On The Map
//
//  Created by Frédéric Lépy on 03/05/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Set the buttons in the Navbar
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh:")
        let pinButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "postInformation")
        self.navigationItem.setRightBarButtonItems([refreshButton, pinButton], animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        
        self.loadUsersData()
    }
    
    
    func loadUsersData() {
        
        ParseAPI.getStudentLocations(100) { (success, error, results) -> () in
            if success {
                //save the data
                AppDelegate.users = results!["results"] as? [[String:AnyObject]]
            } else {
                self.displayError(error!)
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let entries = AppDelegate.users?.count
        //println("There are \(entries) entries in the table")
        if entries != nil {
            return entries!
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        cell.imageView?.image = UIImage(named: "pin")
        
        if let user = AppDelegate.users?[indexPath.row] {
            let firstname = user["firstName"] as? String ?? String()
            let lastname = user["lastName"] as? String ?? String()
            let fullname = firstname + " " + lastname
            cell.textLabel?.text = fullname
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let user = AppDelegate.users?[indexPath.row]
        self.performSegueWithIdentifier("towardStudentUrl", sender: user)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "towardStudentUrl" {
            
            let user = sender as! [String:AnyObject]
            let webView = segue.destinationViewController as! WebViewController
            webView.urlString = user["mediaURL"] as? String
        }
    }
    
    func displayError(error: NSError) {
        let alertController = UIAlertController(title: "Error", message: error.description, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: { (action) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func refresh(sender: AnyObject) {
        self.loadUsersData()
    }
    
    func postInformation() {
        performSegueWithIdentifier("towardInformationPost", sender: self)
    }
}
