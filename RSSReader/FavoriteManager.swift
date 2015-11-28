//
//  FavoriteManager.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-11-27.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation

let FavoriteManagerInstance = FavoriteManager()

class FavoriteManager: NSObject {
    
    var database: FMDatabase? = nil
    
    class func getInstance() -> FavoriteManager {
        if(FavoriteManagerInstance.database == nil) {
            FavoriteManagerInstance.database = FMDatabase(path: Util.getPath("database.sqlite"))
        }
        return FavoriteManagerInstance
    }
    
    var postTitle: String = String()
    var postLink: String = String()
    var postImage: String = String()
    var postDescription: String = String()
    var postPubDate = String()
    
    func insert(feed: Feed) -> Bool {
        FavoriteManagerInstance.database!.open()
        let isInserted = FavoriteManagerInstance.database!.executeUpdate("INSERT INTO favorites (title, link, image, description, date) VALUES (?, ?)", withArgumentsInArray: [feed.postTitle, feed.postLink, feed.postImage, feed.postDescription, feed.postPubDate])
        FavoriteManagerInstance.database!.close()
        return isInserted
    }
    
    func update(feed: Feed) -> Bool {
        FavoriteManagerInstance.database!.open()
        let isUpdated = FavoriteManagerInstance.database!.executeUpdate("UPDATE favorites SET title=?, link=?, image=?, description=?, date=? WHERE id=?", withArgumentsInArray: [feed.postTitle, feed.postLink, feed.postImage, feed.postDescription, feed.postPubDate])
        FavoriteManagerInstance.database!.close()
        return isUpdated
    }
    
    func remove(feed: Feed) -> Bool {
        FavoriteManagerInstance.database!.open()
        let isDeleted = FavoriteManagerInstance.database!.executeUpdate("DELETE FROM favorites WHERE id=?", withArgumentsInArray: [feed.id])
        FavoriteManagerInstance.database!.close()
        return isDeleted
    }
    
    func selectAll() -> NSMutableArray {
        FavoriteManagerInstance.database!.open()
        let resultSet: FMResultSet! = FavoriteManagerInstance.database!.executeQuery("SELECT * FROM favorites", withArgumentsInArray: nil)
        let feeds : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let feed : Feed = Feed()
                feed.id = resultSet.stringForColumn("id")
                feed.postTitle = resultSet.stringForColumn("title")
                feed.postLink = resultSet.stringForColumn("link")
                feed.postImage = resultSet.stringForColumn("image")
                feed.postDescription = resultSet.stringForColumn("description")
                feed.postPubDate = resultSet.stringForColumn("date")
                feeds.addObject(feed)
            }
        }
        FavoriteManagerInstance.database!.close()
        return feeds
    }
}
