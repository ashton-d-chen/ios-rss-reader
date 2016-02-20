//
//  Subscription.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-10-25.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation

class Subscriptions {
 /*   var collection : [Subscription]
    //var dao : SubscriptionDAO
    static let instance = Subscriptions()
    
    private init () {
        self.collection = [Subscription]()
     /*   self.dao = SubscriptionDAO()
        for row in dao.selectAll() {
            self.collection.append(Subscription(subscriptions : self, id : row[SubscriptionField.ID], link : row[SubscriptionField.LINK]))
        }*/
    }
    
    func add (subscription : Subscription) {
        self.collection.append(subscription)
        self.dao.insert(subscription.getLink())
    }
    
    func remove (subscription : Subscription) {
        var count = 0
        for item in self.collection {
            if (item.getId() == subscription.getId()) {
                self.collection.removeFirst(count)
            }
            count += 1
        }
    }
    
    func get (index : Int) -> Subscription {
        return self.collection[index]
    }
    
    func getAll () -> [Subscription] {
        return self.collection
    }
    
    func getCount () -> Int {
        return self.collection.count
    }
*/
}