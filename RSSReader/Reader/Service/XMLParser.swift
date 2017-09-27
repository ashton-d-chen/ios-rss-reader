//
//  XMLParser.swift
//  SplitAndPopover
//
//  Created by Gabriel Theodoropoulos on 17/9/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit

@objc protocol myXMLParserDelegate{
    func parsingWasFinished(index : Int)
    func parsingError()
}

class myXMLParser: NSObject, XMLParserDelegate {
    var delegate : myXMLParserDelegate?
    var eName: String = String()
    var parser: XMLParser = XMLParser()
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
        if let url = URL(string : rssURL ) {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    // MARK: NSXMLParserDelegate method implementation
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
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
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let feed: Feed = Feed()
            
            feed.rssImage = rssImage
            feed.postGuid = postGuid
            
            postTitle = postTitle.replacingOccurrences(of: "&#039;", with: "'")
            feed.postTitle = postTitle
            
            feed.postLink = postLink
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss vvv"
            
            if let date = dateFormatter.date(from: postPubDate) {
                let timezone = TimeZone.current.abbreviation
                dateFormatter.timeZone = TimeZone(abbreviation: "\(timezone)")
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formatedDate = dateFormatter.string(from: date)
                feed.postPubDate = formatedDate
            }
            
            if hasImage {
                feed.postImage = postImage
            } else {
                let range = NSMakeRange(0, self.postDescription.characters.count)
                do {
                    let regex = try NSRegularExpression(pattern: "(<img.*?src=[\"\'])(.*?)([\"\'].*?>)", options: [])
                    regex.enumerateMatches(in: self.postDescription, options: [], range: range) { (result, _, _) -> Void in
                        let nsrange = result!.range(at: 2)
                        let start = self.postDescription.index(self.postDescription.startIndex, offsetBy: nsrange.location)
                        let end = self.postDescription.index(start, offsetBy: nsrange.length)
                        feed.postImage = String(self.postDescription[start..<end])
                    }
                } catch  {
                    NSLog("Can't acquire image URL from CDATA")
                }
            }
            
            // Remove tags
            postDescription = postDescription.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            
            // Trim string
            postDescription = postDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            feed.postDescription = postDescription
            
            feeds.append(feed)
        }
    }
    
    // 4
    func parserDidEndDocument(_ parser: XMLParser) {
        delegate?.parsingWasFinished(index: self.index)
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
