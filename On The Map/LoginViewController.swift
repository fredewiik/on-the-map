//
//  ViewController.swift
//  On The Map
//
//  Created by Frédéric Lépy on 02/05/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.setTitle("Connecting...", forState: UIControlState.Disabled)
        loginButton.setTitle("Login", forState: .Normal) // This is making the button's title back to "Login", but only after a delay. Can't figure out why?
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        
        self.performSegueWithIdentifier("towardUdacity", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "towardUdacity" {
            let webViewController = segue.destinationViewController as! WebViewController
            webViewController.urlString = "https://www.udacity.com"
        }
    }
    
    
    @IBAction func login(sender: AnyObject) {
        
        view.endEditing(true)
        loginButton.enabled = false
        
        if (!emailTextField.text.isEmpty || !passwordTextField.text.isEmpty) {
        
            UdacityAPI.authenticate(emailTextField.text, password: passwordTextField.text) { (success, errorString, results) in
            
                if success {
                    //println(results)
                    self.completeLogin()
                
                } else {
                    self.displayError(errorString!)
                }
            }
        } else {
            displayError("Please type in your login and password")
        }
    }
    
    
    func completeLogin() {
        
        println("login succeeded")
        
        UdacityAPI.getUserData { (success, error) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue(), {self.performSegueWithIdentifier("loginSucceededSegue", sender: self)})
            } else {
                dispatch_async(dispatch_get_main_queue(), {self.displayError(error!.description)})
            }
        }
    }
    
    
    func displayError(errorString: String) {
        
        loginButton.enabled = true
        
        let alertController = UIAlertController(title: "Login failed", message: errorString, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: { (action) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.login(self)
        return true
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
    }
    
}

