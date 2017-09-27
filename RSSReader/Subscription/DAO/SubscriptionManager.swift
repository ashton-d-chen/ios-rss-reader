//
//  ModelManager.swift
//  DataBaseDemo
//
//  Created by Krupa-iMac on 05/08/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

let sharedInstance : SubscriptionManager = SubscriptionManager()

class SubscriptionManager: NSObject {
    var database: FMDatabase!
    let databaseFileName = "database.sqlite"
    var pathToDatabase: String!
    
    override init()
    {
        super.init()
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)

            if (database == nil)
            {
                print("Could not open the database.")
                return false;
            }
            
            createTable()
            
            //            if (database?.open())! {
            //                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
            //                if !(database?.executeStatements(sql_stmt))! {
            //                }
            //                database?.close()
            //            } else {
            //                print("Error: \(database?.lastErrorMessage())")
            //            }
            //
            //            let resultSet : FMResultSet! =  sharedInstance.database!.executeQuery("SELECT * FROM subscriptions WHERE rss_url = 'http://rss.cnn.com/rss/cnn_topstories.rss'", withArgumentsIn: nil)
            //
            created = true
        }
        return created
    }
    
    class func getInstance() -> SubscriptionManager
    {
        if(sharedInstance.database == nil)
        {
            if (!sharedInstance.createDatabase())
            {
                print("Could not create the database.")
            }
            //            sharedInstance.database = FMDatabase(path: Util.getPath(fileName: "database.sqlite"))
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
        if selectSubscription(subscription: subscription) == nil {
            isInserted = sharedInstance.database!.executeUpdate("INSERT INTO subscriptions (rss_url, title, web_url, description, image_url, pub_date) VALUES (?, ?, ?, ?, ?, ?)", withArgumentsIn: [subscription.rssURL, subscription.rssTitle, subscription.rssWebURL, subscription.rssDescription, subscription.rssImageURL, subscription.rssPubDate])
            sharedInstance.database!.close()
        }
        return isInserted
    }
    
    func update(subscription: Subscription) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE subscriptions SET title=?, web_url=? WHERE rss_url=?", withArgumentsIn: [subscription.rssTitle, subscription.rssWebURL, subscription.rssURL])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func remove(subscription: Subscription) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM subscriptions WHERE rss_url=? LIMIT 1", withArgumentsIn: [subscription.rssURL])
        sharedInstance.database!.close()
        return isDeleted
    }
    
    func selectSubscription(subscription : Subscription) -> Subscription? {
        if sharedInstance.database!.open() {
            let resultSet : FMResultSet! =  sharedInstance.database!.executeQuery("SELECT * FROM subscriptions WHERE rss_url = '\(subscription.rssURL)'", withArgumentsIn: nil)
            let subscription : Subscription = Subscription()
            
            if (resultSet != nil && resultSet.next() == true) {
                subscription.rssURL = resultSet.string(forColumn: "rss_url")
                subscription.rssTitle = resultSet.string(forColumn: "title")
                subscription.rssWebURL = resultSet.string(forColumn: "web_url")
                subscription.rssDescription = resultSet.string(forColumn: "description")
                subscription.rssImageURL = resultSet.string(forColumn: "image_url")
                subscription.rssPubDate = resultSet.string(forColumn: "pub_date")
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
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM subscriptions", withArgumentsIn: nil)
        let subscriptions : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let subscription : Subscription = Subscription()
                subscription.rssURL = resultSet.string(forColumn: "rss_url")
                subscription.rssTitle = resultSet.string(forColumn: "title")
                subscription.rssWebURL = resultSet.string(forColumn: "web_url")
                subscription.rssDescription = resultSet.string(forColumn: "description")
                subscription.rssImageURL = resultSet.string(forColumn: "image_url")
                subscription.rssPubDate = resultSet.string(forColumn: "pub_date")
                subscriptions.add(subscription)
            }
        }
        sharedInstance.database!.close()
        return subscriptions
    }
}
