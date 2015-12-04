//
//  XMLParser.swift
//  SplitAndPopover
//
//  Created by Gabriel Theodoropoulos on 17/9/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit

@objc protocol XMLParserDelegate{
    func parsingWasFinished(index : Int)
    func parsingError()
}

class XMLParser: NSObject, NSXMLParserDelegate {
    var delegate : XMLParserDelegate?
    var eName: String = String()
    var parser: NSXMLParser = NSXMLParser()
    var feeds: [Feed] = []
    var rssImage: String = String()
    var postTitle: String = String()
    var postLink: String = String()
    var postGuid: String = String()
    var postImage: String = String()
    var postDescription: String = String()
    var postPubDate : String = String()
    var hasImage:Bool = false
    var imageCache = [String : UIImage]()
    var start = 0
    var index : Int = 0
    
    func query(rssURL: String) {
        if let url = NSURL(string : rssURL ) {
            if let parser = NSXMLParser(contentsOfURL: url) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    // MARK: NSXMLParserDelegate method implementation
    // 1
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        eName = elementName
        
        if elementName == "image" {
            rssImage = String()
        }
        
        if elementName == "item" {
            postGuid = String()
            postTitle = String()
            postLink = String()
            postImage = String()
            postDescription = String()
            postPubDate = String()
            hasImage = false
        }
        
        if elementName == "media:thumbnail" {
            if let obj: String = attributeDict["url"] as AnyObject? as? String {
                postImage = obj
                hasImage = true
            }
        }
    }
    
    // 2
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let data: String = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if (!data.isEmpty) {
            if eName == "url" {
                rssImage += data
            } else if eName == "guid" {
                postGuid += data
            } else if eName == "title" {
                postTitle += data
            } else if eName == "link" {
                postLink += data
            } else if eName == "description" {
                postDescription += data
            } else if eName == "pubDate" {
                postPubDate += data
            }
        }
    }
    
    // 3
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let feed: Feed = Feed()

            feed.rssImage = rssImage
            feed.postGuid = postGuid
            
            postTitle = postTitle.stringByReplacingOccurrencesOfString("&#039;", withString: "'")
            feed.postTitle = postTitle
            
            
            feed.postLink = postLink
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss vvv"
            
            if let date = dateFormatter.dateFromString(postPubDate) {
                let timezone = NSTimeZone.localTimeZone().abbreviation
                dateFormatter.timeZone = NSTimeZone(name: "\(timezone)")
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formatedDate = dateFormatter.stringFromDate(date)
                feed.postPubDate = formatedDate
            }
            
            if hasImage {
                feed.postImage = postImage
            } else {
                let range = NSMakeRange(0, self.postDescription.characters.count)
                do {
                    let regex = try NSRegularExpression(pattern: "(<img.*?src=[\"\'])(.*?)([\"\'].*?>)", options: [])
                    regex.enumerateMatchesInString(self.postDescription, options: [], range: range) { (result, _, _) -> Void in
                        let nsrange = result!.rangeAtIndex(2)
                        let start = self.postDescription.startIndex.advancedBy(nsrange.location)
                        let end = start.advancedBy(nsrange.length)
                        feed.postImage = self.postDescription[start..<end]
                    }
                } catch  {
                    NSLog("Can't acquire image URL from CDATA")
                }
            }
            
            // Remove tags
            postDescription = postDescription.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
            
            // Trim string
            postDescription = postDescription.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            feed.postDescription = postDescription
            
            feeds.append(feed)
        }
    }
    
    // 4
    func parserDidEndDocument(parser: NSXMLParser) {
        delegate?.parsingWasFinished(self.index)
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        print("error")
        print(parseError.description)
        delegate?.parsingError()
    }
    
    func parser(parser: NSXMLParser, validationErrorOccurred validationError: NSError) {
        print("error")
        print(validationError.description)
        delegate?.parsingError()
    }
}
