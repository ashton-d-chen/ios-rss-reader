//
//  ModelManager.swift
//  DataBaseDemo
//
//  Created by Krupa-iMac on 05/08/14.
//  Copyright (c) 2014 TheAppGuruz. All rights reserved.
//

import UIKit

let sharedInstance = ModelManager()

class ModelManager: NSObject {
    
    var database: FMDatabase? = nil

    class func getInstance() -> ModelManager
    {
        if(sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: Util.getPath("database.sqlite"))
        }
        return sharedInstance
    }
    
    func insert(subscription: Subscription) -> Bool {
        sharedInstance.database!.open()
        let isInserted = sharedInstance.database!.executeUpdate("INSERT INTO subscriptions (name, link) VALUES (?, ?)", withArgumentsInArray: [subscription.name, subscription.link])
        sharedInstance.database!.close()
        return isInserted
    }
   
    func update(subscription: Subscription) -> Bool {
        sharedInstance.database!.open()
        let isUpdated = sharedInstance.database!.executeUpdate("UPDATE subscriptions SET name=?, link=? WHERE id=?", withArgumentsInArray: [subscription.name, subscription.link, subscription.id])
        sharedInstance.database!.close()
        return isUpdated
    }
    
    func remove(subscription: Subscription) -> Bool {
        sharedInstance.database!.open()
        let isDeleted = sharedInstance.database!.executeUpdate("DELETE FROM subscriptions WHERE id=?", withArgumentsInArray: [subscription.id])
        sharedInstance.database!.close()
        return isDeleted
    }

    func selectAll() -> NSMutableArray {
        sharedInstance.database!.open()
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM subscriptions", withArgumentsInArray: nil)
        let subscriptions : NSMutableArray = NSMutableArray()
        if (resultSet != nil) {
            while resultSet.next() {
                let subscription : Subscription = Subscription()
                subscription.id = resultSet.stringForColumn("id")
                subscription.name = resultSet.stringForColumn("name")
                subscription.link = resultSet.stringForColumn("link")
                subscriptions.addObject(subscription)
            }
        }
        sharedInstance.database!.close()
        return subscriptions
    }
}
