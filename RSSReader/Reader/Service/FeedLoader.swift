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
    var count : Int = 0
    
    override init() {
        super.init()
        self.reset()
    }
    
    func reset() {
        self.subscriptions = NSMutableArray()
        self.subscriptions = SubscriptionManager.getInstance().selectAll()
        self.xmlParsers = [XMLParser]()
        self.count = 0
        feeds = [Feed]()
    }
    
    func load() {
        reset()
        if self.subscriptions.count > 0 {
            for var i = 0; i < self.subscriptions.count; i++ {
                let subscription : Subscription = self.subscriptions[i] as! Subscription
                let url : String = subscription.rssURL
                let xmlParser = XMLParser()
                xmlParser.index = i
                xmlParser.delegate = self
                xmlParsers.append(xmlParser)
                xmlParser.query(url)
            }
        } else {
            self.delegate?.loadingFinished()
        }
    }
    
    func parsingWasFinished(index : Int) {
        feeds += xmlParsers[index].feeds
        self.count++
        if (self.count == self.subscriptions.count) {
            self.feeds.sortInPlace { $0.postPubDate.localizedCaseInsensitiveCompare($1.postPubDate) == NSComparisonResult.OrderedDescending }
            self.delegate?.loadingFinished()
        }
    }
    
    func parsingError() {
        self.count++
        if (self.count == self.subscriptions.count) {
            self.feeds.sortInPlace { $0.postPubDate.localizedCaseInsensitiveCompare($1.postPubDate) == NSComparisonResult.OrderedDescending }
            self.delegate?.loadingFinished()
        }
    }
}