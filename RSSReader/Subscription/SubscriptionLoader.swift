//
//  SubscriptionLoader.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-12-04.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation

@objc protocol SubscriptionLoadingDelegate {
    func loadingFinished(subscription : Subscription)
    func loadingError()
}

/*
class SubscriptionLoader: NSObject, SubscriptionXMLParserDelegate {
    var delegate : SubscriptionLoadingDelegate?
    var feeds = [Feed]()
    //var xmlParsers = [XMLParser]()
    var subscriptions : NSMutableArray!
    var count : Int = 0
    
    override init() {
        super.init()
        self.reset()
    }
    
    func reset() {
        self.subscriptions = NSMutableArray()
        self.subscriptions = ModelManager.getInstance().selectAll()
        //self.xmlParsers = [XMLParser]()
        self.count = 0
        feeds = [Feed]()
    }
    
    func loadSingleSubscriptionInfo(url : String) {
        let xmlParser = SubscriptionXMLParser()
        xmlParser.delegate = self
        xmlParser.query(url)
    }
    
    func parsingWasFinished(subscription : Subscription) {
        self.delegate?.loadingFinished(subscription)
    }
    
    func parsingError() {
            self.delegate?.loadingError()
    }
}
*/