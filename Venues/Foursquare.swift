//
//  Foursquare.swift
//  Venues
//
//  Created by Joe E. on 10/6/15.
//  Copyright © 2015 Joe E. All rights reserved.
//

import UIKit
import CoreLocation

typealias Dictionary = [String:AnyObject]

private let API_URl = "https://api.foursquare.com/v2/"
private let _singleton = Foursquare()

class Foursquare: NSObject {
    class func session() -> Foursquare {
        return _singleton
        
    }
    
    var venues: [Dictionary] = []
    
    func getVenuesWithLocation(location: CLLocation, completion: () -> ()) {
        let urlString = API_URl + "venues/search?=v=20130815&client_id=" + CLIENT_ID + "&client_secret=" + CLIENT_SECRET + "&ll=\(location.coordinate.latitude),\(location.coordinate.longitude)"
        
        if let url = NSURL(string: urlString) {
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if let data = data {
                    if let resultInfo = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? Dictionary {
                        if let responseInfo = resultInfo?["response"] as? Dictionary {
                            self.venues = responseInfo["venues"] as? [Dictionary] ?? []
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion()
                                
                            })
                            

                            
                        }
                        
                    }
                    
                }
                
            })
            
            task.resume()
            
        }
        
    }

}