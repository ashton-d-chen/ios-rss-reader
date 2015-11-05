//
//  Feed.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-10-30.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation

class Feed {
    var title : String
    var text : String
    var image : String
    var link : String
    
    init(title : String, text : String, image : String, link : String) {
        self.title = title
        self.text = text
        self.image = image
        self.link = link
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getText() -> String {
        return self.text
    }
    
    func getImage() -> String {
        return self.image
    }
    
    func getLink() -> String {
        return self.link
    }
}