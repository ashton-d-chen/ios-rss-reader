//
//  FeedLoader.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-11-24.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation

@objc protocol FeedLoadingDelegate{
    func loadingFinished()
}


class FeedLoader: NSObject, XMLParserDelegate {
    var delegate : FeedLoadingDelegate?
    var feeds = [Feed]()
    var xmlParsers = [XMLParser]()
    var subscriptions : NSMutableArray!
    var count = 0
    
    override init() {
        self.subscriptions = NSMutableArray()
        self.subscriptions = ModelManager.getInstance().selectAll()
        self.count = 0
        
    }
    
    func load() {
        for var i = 0; i < self.subscriptions.count; i++ {
            let subscription : Subscription = self.subscriptions[i] as! Subscription
            let url : String = subscription.link
            let xmlParser = XMLParser()
            xmlParser.index = i
            xmlParser.delegate = self
            xmlParsers.append(xmlParser)
            xmlParser.query(url)
        }
    }
    
    func parsingWasFinished(index : Int) {
        feeds += xmlParsers[index].feeds
        self.count++
        if (self.count == self.subscriptions.count) {
            self.delegate?.loadingFinished()
        }
    }
    
    func parsingError() {
        self.count++
        if (self.count == self.subscriptions.count) {
            self.delegate?.loadingFinished()
        }
    }
}