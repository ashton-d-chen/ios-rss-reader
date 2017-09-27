//
//  SubscriptionXMLParser.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-12-04.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import UIKit

@objc protocol SubscriptionXMLParserDelegate{
    func subscriptionParsed(subscription : Subscription)
    func parsingError()
}

class SubscriptionXMLParser: NSObject, XMLParserDelegate {
    var delegate : SubscriptionXMLParserDelegate?
    var eName: String = String()
    var parser: XMLParser = XMLParser()
    
    var rssURL: String = String()
    var rssTitle: String = String()
    var rssWebURL: String = String()
    var rssDescription: String = String()
    var rssPubDate : String = String()
    var rssImageURL: String = String()
    var hasImage:Bool = false
    
    var isTitleDone = false
    var isLinkDone = false
    var isDescriptionDone = false
    var isPubDateDone = false
    var isImageDone = false
    var isAllDone:Bool = false
    
    func query(rssURL: String) {
        print("query string \(rssURL)")
        self.rssURL = rssURL
        if let url = URL(string : self.rssURL ) {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    // MARK: NSXMLParserDelegate method implementation
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if (self.eName == "title" &&  elementName != self.eName) {
            self.isTitleDone = true
        } else if (self.eName == "link" &&  elementName != self.eName) {
            self.isLinkDone = true
        } else if (self.eName == "description" &&  elementName != self.eName) {
            self.isDescriptionDone = true
        } else if (self.eName == "pubDate" &&  elementName != self.eName) {
            self.isPubDateDone = true
        } else if (self.eName == "url" &&  elementName != self.eName) {
            self.isImageDone = true
        }
        
        if elementName == "item" {
            isAllDone = true
        }
        
        eName = elementName
    }
    
    // 2
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (!isAllDone) {
            let data: String = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if (!data.isEmpty) {
                if self.eName == "title" && !self.isTitleDone {
                    self.rssTitle += data
                } else if self.eName == "link" && !self.isLinkDone {
                    self.rssWebURL += data
                } else if self.eName == "description" && !self.isDescriptionDone {
                    self.rssDescription += data
                } else if self.eName == "pubDate" && !self.isPubDateDone {
                    rssPubDate += data
                } else if self.eName == "url" && !self.isImageDone {
                    self.rssImageURL += data
                }
            }
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    }
    
    // 4
    func parserDidEndDocument(_ parser: XMLParser) {
        let subscription = Subscription()
        print(self.rssURL + "\n\n")
        subscription.rssURL = self.rssURL
        subscription.rssTitle = self.rssTitle
        subscription.rssWebURL = self.rssWebURL
        subscription.rssDescription = self.rssDescription
        subscription.rssImageURL = self.rssImageURL
        subscription.rssPubDate = self.rssPubDate
        delegate?.subscriptionParsed(subscription: subscription)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("error")
        //        print(parseError.description)
        delegate?.parsingError()
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        print("error")
        //        print(validationError.description)
        delegate?.parsingError()
    }
}
