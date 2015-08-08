//
//  Loader.swift
//  Behtarin
//
//  Created by Max Vitruk on 08.08.15.
//  Copyright (c) 2015 todo. All rights reserved.
//

import Foundation
import UIKit

protocol LoadCallBack {
    func loadDidFinish(sender : AnyObject)
}

class Loader {
    
    private var loadCallBack : LoadCallBack!
    
    init(){}
    
    init(callBack : LoadCallBack){
        self.loadCallBack = callBack
    }
    
    func getFromUrl(urlPath : String) {
        var url : NSString = urlPath
        var urlStr : NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        var searchURL : NSURL = NSURL(string: urlStr as String)!
        println(searchURL)
        let session = NSURLSession.sharedSession()
        
        var error:NSError?
        
        let task = session.dataTaskWithURL(searchURL, completionHandler: {data, response, error -> Void in
            
            if(error != nil) {
                println(error!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            //println("\(jsonResult)")
            if err != nil {
                // If there is an error parsing JSON, print it to the console
                println("JSON Error \(err!.localizedDescription)")
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadCallBack.loadDidFinish(jsonResult)
                });
            }
        })
        task.resume()
    }
    
}

