//
//  WebViewController.swift
//  On The Map
//
//  Created by Frédéric Lépy on 02/05/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    var urlString : String?
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWebPage()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWebPage() {
        //let urlString = "https://www.udacity.com"
        let url = NSURL(string: self.urlString!)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }

    @IBAction func dismissWebView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
