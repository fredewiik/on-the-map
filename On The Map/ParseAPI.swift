//
//  ParseAPI.swift
//  On The Map
//
//  Created by Frédéric Lépy on 03/05/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import Foundation
import MapKit

class ParseAPI {
    
    static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    class func getStudentLocations(limit: Int, completionHandler:(success: Bool, error: NSError?, results: NSDictionary?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        request.addValue(ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                completionHandler(success: false, error: error, results: nil)
                return
            }
            //println(NSString(data: data, encoding: NSUTF8StringEncoding))
            
            //Parse the data
            var parsingError: NSError? = nil
            let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary?
            if parsingError != nil {
                println("Parsing error: \(parsingError?.description)")
                completionHandler(success: false, error: parsingError!, results: nil)
                return
            }
            
            // If No errors
            completionHandler(success: true, error: nil, results: parsedResult!)
        }
        task.resume()
    }
    
    class func postStudentLocation(mapString:String, url:NSURL, latitude:CLLocationDegrees, longitude:CLLocationDegrees, completionHandler:(success:Bool, error:NSError?) -> Void) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
        
        let firstname = StudentInformation.name
        println(firstname)
        
        request.HTTPMethod = "POST"
        request.addValue(ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"\(firstname!)\", \"lastName\": \"Secret\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(url)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completionHandler(success: false, error: error)
                return
            }
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            completionHandler(success: true, error: nil)
        }
        task.resume()
    }
    
}