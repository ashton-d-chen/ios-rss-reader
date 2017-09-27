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
            FavoriteManagerInstance.database = FMDatabase(path: Util.getPath(fileName: "database.sqlite"))
            FavoriteManagerInstance.createTable()
        }
        return FavoriteManagerInstance
    }
    
    func createTable() {
        if FavoriteManagerInstance.database!.open() {
            let query = "CREATE TABLE IF NOT EXISTS favorites (id TEXT, title TEXT, link TEXT, image TEXT, description TEXT, date TEXT)"
            FavoriteManagerInstance.database!.executeStatements(query)
            FavoriteManagerInstance.database!.close()
        }
    }
    
    func insert(feed: Feed) -> Bool {
        var isInserted = false
        
        if self.select(feed: feed) == nil {
            if FavoriteManagerInstance.database!.open() {
                isInserted = FavoriteManagerInstance.database!.executeUpdate("INSERT INTO favorites (id, title, link, image, description, date) VALUES (?, ?, ?, ?, ?, ?)", withArgumentsIn: [feed.id, feed.postTitle, feed.postLink, feed.postImage, feed.postDescription, feed.postPubDate])
                FavoriteManagerInstance.database!.close()
            }
        }
        return isInserted
    }
    
    func update(feed: Feed) -> Bool {
        var isUpdated = false
        if FavoriteManagerInstance.database!.open() {
            isUpdated = FavoriteManagerInstance.database!.executeUpdate("UPDATE favorites SET title=?, link=?, image=?, description=?, date=? WHERE id=?", withArgumentsIn: [feed.postTitle, feed.postLink, feed.postImage, feed.postDescription, feed.postPubDate])
            FavoriteManagerInstance.database!.close()
        }
        return isUpdated
    }
    
    func remove(feed: Feed) -> Bool {
        var isDeleted = false
        if FavoriteManagerInstance.database!.open() {
            isDeleted = FavoriteManagerInstance.database!.executeUpdate("DELETE FROM favorites WHERE link=? LIMIT 1", withArgumentsIn: [feed.postLink])
            FavoriteManagerInstance.database!.close()
        }
        return isDeleted
    }
    
    func select(feed : Feed) -> Feed? {
        if FavoriteManagerInstance.database!.open() {
            let query = "SELECT * FROM favorites WHERE link = '\(feed.postLink)'"
            let resultSet : FMResultSet = FavoriteManagerInstance.database!.executeQuery(query, withArgumentsIn: nil)
            let feed = Feed()
            if resultSet.next() == true {
                feed.id = resultSet.string(forColumn: "id")
                feed.postTitle = resultSet.string(forColumn: "title")
                feed.postLink = resultSet.string(forColumn: "link")
                feed.postImage = resultSet.string(forColumn: "image")
                feed.postDescription = resultSet.string(forColumn: "description")
                feed.postPubDate = resultSet.string(forColumn: "date")
            } else {
                return nil
            }
            FavoriteManagerInstance.database!.close()
            return feed
        }
        return nil
    }
    
    func selectAll() -> NSMutableArray {
        let feeds : NSMutableArray = NSMutableArray()
        if FavoriteManagerInstance.database!.open() {
            let resultSet: FMResultSet! = FavoriteManagerInstance.database!.executeQuery("SELECT * FROM favorites", withArgumentsIn: nil)
            
            if (resultSet != nil) {
                while resultSet.next() {
                    let feed : Feed = Feed()
                    feed.id = resultSet.string(forColumn: "id")
                    feed.postTitle = resultSet.string(forColumn: "title")
                    feed.postLink = resultSet.string(forColumn: "link")
                    feed.postImage = resultSet.string(forColumn: "image")
                    feed.postDescription = resultSet.string(forColumn: "description")
                    feed.postPubDate = resultSet.string(forColumn: "date")
                    feeds.add(feed)
                }
            }
            FavoriteManagerInstance.database!.close()
        }
        return feeds
    }
}
