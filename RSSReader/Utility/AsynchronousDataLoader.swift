//
//  AsynchronouslyLoader.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-12-04.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation

func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
    NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
        completion(data: data, response: response, error: error)
        }.resume()
}