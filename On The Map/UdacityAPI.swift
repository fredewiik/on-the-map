//
//  Udacity API.swift
//  On The Map
//
//  Created by Frédéric Lépy on 02/05/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit
import MapKit

class UdacityAPI {
    
    static let baseURL = "https://www.udacity.com/api/session"
    
    class func authenticate(email: String, password: String, completionHandler: (success: Bool, errorString: String?, results: NSDictionary?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error…
                println("login error")
                completionHandler(success: false, errorString: error.description, results: nil)
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            //println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            // Parse the results
            var parsingError: NSError? = nil
            let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            if parsingError != nil {
                println("Parsing error: \(parsingError?.description)")
                completionHandler(success: false, errorString: parsingError?.description, results: nil)
                return
            }
            
            // If there is an error msg inside the parsed result, the login has failed
            if let loginErrorString = parsedResult.valueForKey("error") as? String {
                println(loginErrorString)
                
                completionHandler(success: false, errorString: loginErrorString, results: nil)
                return
            }
            // No error at all
            completionHandler(success: true, errorString: nil, results: parsedResult)
        }
        
        task.resume()
    }
    
    
    class func getUserData(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/3903878747")!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error...
                completionHandler(success: false, error: error)
                return
            }
            
            /*
            This is a given function where only the nickname appears in the returned newData
            Therefore I use only the nickname for firstname. Regarding the lastname, I've hardcoded it to Secret when the user sends his data
            */
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            //println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
            //Parse the results
            var parsingError: NSError? = nil
            let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
            let result = parsedResult["user"] as! NSDictionary
            if parsingError != nil {
                completionHandler(success: false, error: parsingError!)
                return
            }
            
            // If No errors
            StudentInformation.name = result["nickname"] as? String
            StudentInformation.location = result["location"] as? CLLocationDegrees
            StudentInformation.link = result["website_url"] as? String
            
            completionHandler(success: true, error: nil)
        }
        
        task.resume()
    }
    
}
