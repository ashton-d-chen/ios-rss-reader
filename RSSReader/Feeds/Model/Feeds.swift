//
//  Feeds.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-10-30.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation

class Feeds {
    var collection : [Feed]
    
    init () {
        self.collection = [Feed]()
    }
    
    func add (feed : Feed) {
        self.collection.append(feed)
    }
    
    func remove (feed : Feed) {

    }
    
    func get (index : Int) -> Feed {
        return self.collection[index]
    }
    
    func getAll () -> [Feed] {
        return self.collection
    }
    
    func getCount () -> Int {
        return self.collection.count
    }
}