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


class FeedLoader: NSObject, myXMLParserDelegate {
    var delegate : FeedLoadingDelegate?
    var feeds = [Feed]()
    var xmlParsers = [myXMLParser]()
    var subscriptions : NSMutableArray!
    var count : Int = 0
    
    override init() {
        super.init()
        self.reset()
    }
    
    func reset() {
        self.subscriptions = NSMutableArray()
        self.subscriptions = SubscriptionManager.getInstance().selectAll()
        self.xmlParsers = [myXMLParser]()
        self.count = 0
        feeds = [Feed]()
    }
    
    func load() {
        reset()
        if self.subscriptions.count > 0 {
            for i in 0 ... self.subscriptions.count - 1 {
                let subscription : Subscription = self.subscriptions[i] as! Subscription
                let url : String = subscription.rssURL
                let xmlParser = myXMLParser()
                xmlParser.index = i
                xmlParser.delegate = self
                xmlParsers.append(xmlParser)
                xmlParser.query(rssURL: url)
            }
        } else {
            self.delegate?.loadingFinished()
        }
    }
    
    func parsingWasFinished(index : Int) {
        feeds += xmlParsers[index].feeds
        self.count = +1
        if (self.count == self.subscriptions.count) {
            self.feeds.sort { $0.postPubDate.localizedCaseInsensitiveCompare($1.postPubDate) == ComparisonResult.orderedDescending }
            self.delegate?.loadingFinished()
        }
    }
    
    func parsingError() {
        self.count = +1
        if (self.count == self.subscriptions.count) {
            self.feeds.sort { $0.postPubDate.localizedCaseInsensitiveCompare($1.postPubDate) == ComparisonResult.orderedDescending }
            self.delegate?.loadingFinished()
        }
    }
}
