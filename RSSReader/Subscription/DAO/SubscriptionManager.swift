//
//  ModelManager.swift
//  DataBaseDemo
//
//  Created by Krupa-iMac on 05/08/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

let SubscriptionManagerInstance : SubscriptionManager = SubscriptionManager()

class SubscriptionManager: NSObject {
    var pathToDatabase : String!
    private var database: FMDatabase!
    
    override init()
    {
        super.init()
        let databaseFileName = "database.sqlite"
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    func createDatabase() -> Bool {        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            return false
        }
        
        database = FMDatabase(path: pathToDatabase!)
        
        if (database == nil)
        {
            print("Could not open the database.")
            return false;
        }
        
        createTable()
        
        let subscription = Subscription()
        subscription.rssURL = "https://www.cnet.com/g00/3_c-8yyy.epgv.eqo_/c-8OQTGRJGWU46x24jvvrux3ax2fx2fyyy.epgv.eqox2ftuux2fpgyux2f_$/$/$/$"
        subscription.rssTitle = "CNET News"
        subscription.rssWebURL = "https://www.cnet.com"
        subscription.rssDescription = "CNET news editors and reporters provide top technology news, with investigative reporting and in-depth coverage of tech issues and events."
        subscription.rssImageURL = "http://i.i.cbsi.com/cnwk.1d/i/ne/gr/prtnr/CNET_Logo_150.gif"
        subscription.rssPubDate = "Thu, 28 Sep 2017 02:21:22 +0000"
        
        insert(subscription: subscription)
        
        return true
    }
    
    class func getInstance() -> SubscriptionManager
    {
        
        if(SubscriptionManagerInstance.database != nil)
        {
            return SubscriptionManagerInstance
        }
        
        if (!SubscriptionManagerInstance.createDatabase())
        {
            print("Could not create the database.")
        }
        
        //            sharedInstance.database = FMDatabase(path: Util.getPath(fileName: "database.sqlite"))
        return SubscriptionManagerInstance
    }
    
    func createTable() {
        if database!.open() {
            let query = "CREATE TABLE IF NOT EXISTS subscriptions (rss_url TEXT, title TEXT, web_url TEXT, description TEXT, image_url TEXT, pub_date TEXT)"
            database!.executeStatements(query)
            database!.close()
        }
    }
    
    func insert(subscription: Subscription) -> Bool {
        database!.open()
        var isInserted = false
        if selectSubscription(subscription: subscription) == nil {
            isInserted = database!.executeUpdate("INSERT INTO subscriptions (rss_url, title, web_url, description, image_url, pub_date) VALUES (?, ?, ?, ?, ?, ?)", withArgumentsIn: [subscription.rssURL, subscription.rssTitle, subscription.rssWebURL, subscription.rssDescription, subscription.rssImageURL, subscription.rssPubDate])
            database!.close()
        }
        return isInserted
    }
    
    func update(subscription: Subscription) -> Bool {
        database!.open()
        let isUpdated = database!.executeUpdate("UPDATE subscriptions SET title=?, web_url=? WHERE rss_url=?", withArgumentsIn: [subscription.rssTitle, subscription.rssWebURL, subscription.rssURL])
        database!.close()
        return isUpdated
    }
    
    func remove(subscription: Subscription) -> Bool {
        database!.open()
        let isDeleted = database!.executeUpdate("DELETE FROM subscriptions WHERE rss_url=? LIMIT 1", withArgumentsIn: [subscription.rssURL])
        database!.close()
        return isDeleted
    }
    
    func selectSubscription(subscription : Subscription) -> Subscription? {
        if database!.open() {
            let resultSet : FMResultSet! =  SubscriptionManagerInstance.database!.executeQuery("SELECT * FROM subscriptions WHERE rss_url = '\(subscription.rssURL)'", withArgumentsIn: nil)
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
            database!.close()
            
            return subscription
        }
        return nil
    }
    
    func selectAll() -> NSMutableArray {
        
        database!.open()
        let resultSet: FMResultSet! = SubscriptionManagerInstance.database!.executeQuery("SELECT * FROM subscriptions", withArgumentsIn: nil)
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
        database!.close()
        return subscriptions
    }
}
