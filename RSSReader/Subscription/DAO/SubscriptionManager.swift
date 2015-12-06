//
//  ModelManager.swift
//  DataBaseDemo
//
//  Created by Krupa-iMac on 05/08/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

let sharedInstance = SubscriptionManager()

class SubscriptionManager: NSObject {
    
    var database: FMDatabase? = nil
    
    class func getInstance() -> SubscriptionManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: Util.getPath("database.sqlite"))
        }
        return sharedInstance
    }
    
    func createTable() {
        if sharedInstance.database!.open() {
            let query = "CREATE TABLE IF NOT EXISTS subscriptions (rss_url TEXT, title TEXT, web_url TEXT, description TEXT, image_url TEXT, pub_date TEXT)"
            sharedInstance.database!.executeStatements(query)
            sharedInstance.database!.close()
        }
    }
    
    func insert(subscription: Subscription) -> Bool {
        sharedInstance.database!.open()
        var isInserted = false
        if selectSubscription(subscription) == nil {
            isInserted = sharedInstance.database!.executeUpdate("INSERT INTO subscriptions (rss_url, title, web_url, description, image_url, pub_date) VALUES (?, ?, ?, ?, ?, ?)", withArgumentsInArray: [subscription.rssURL, subscription.rssTitle, subscription.rssWebURL, subscription.rssDescription, subscription.rssImageURL, subscription.rssPubDate])
            sharedInstance.database!.close()
        }
        return isInserted
    }
    
    func update(subscription: Subscription) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE subscriptions SET title=?, web_url=? WHERE rss_url=?", withArgumentsInArray: [subscription.rssTitle, subscription.rssWebURL, subscription.rssURL])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func remove(subscription: Subscription) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM subscriptions WHERE rss_url=? LIMIT 1", withArgumentsInArray: [subscription.rssURL])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    func selectSubscription(subscription : Subscription) -> Subscription? {
        if sharedInstance.database!.open() {
            let query = "SELECT * FROM subscriptions WHERE rss_url = '\(subscription.rssURL)'"
            let resultSet : FMResultSet = sharedInstance.database!.executeQuery(query,
                withArgumentsInArray: nil)
            let subscription : Subscription = Subscription()
            if resultSet.next() == true {
                subscription.rssURL = resultSet.stringForColumn("rss_url")
                subscription.rssTitle = resultSet.stringForColumn("title")
                subscription.rssWebURL = resultSet.stringForColumn("web_url")
                subscription.rssDescription = resultSet.stringForColumn("description")
                subscription.rssImageURL = resultSet.stringForColumn("image_url")
                subscription.rssPubDate = resultSet.stringForColumn("pub_date")
            } else {
                return nil
            }
            FavoriteManagerInstance.database!.close()
            return subscription
        }
        return nil
    }
    
    func selectAll() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM subscriptions", withArgumentsInArray: nil)
        let subscriptions : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let subscription : Subscription = Subscription()
                subscription.rssURL = resultSet.stringForColumn("rss_url")
                subscription.rssTitle = resultSet.stringForColumn("title")
                subscription.rssWebURL = resultSet.stringForColumn("web_url")
                subscription.rssDescription = resultSet.stringForColumn("description")
                subscription.rssImageURL = resultSet.stringForColumn("image_url")
                subscription.rssPubDate = resultSet.stringForColumn("pub_date")
                subscriptions.addObject(subscription)
            }
        }
        sharedInstance.database!.close()
        return subscriptions
    }
}
