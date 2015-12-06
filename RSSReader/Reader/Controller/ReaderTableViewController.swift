//
//  TableTableViewController.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-11-06.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation
import UIKit

class ReaderTableViewController: UITableViewController, FeedLoadingDelegate {
    
    //var xmlParser : XMLParser!
    
    var feedLoader : FeedLoader = FeedLoader()
    var mRefreshControl : UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressReader:")
        self.view.addGestureRecognizer(longPressRecognizer)
        
        feedLoader.delegate = self
        feedLoader.load()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: FeedLoader method implementation
    func loadingFinished() {
        self.tableView.reloadData()
        if mRefreshControl != nil {
            mRefreshControl!.endRefreshing()
            mRefreshControl = nil
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let defaults = NSUserDefaults.standardUserDefaults()
        let maxNumOfFeed = Int(defaults.objectForKey(MAX_NUM_OF_FEED) as! String)!
        
        if feedLoader.feeds.count == 0{
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            
            let subscriptions : NSMutableArray = SubscriptionManager.getInstance().selectAll()
            if subscriptions.count == 0 {
                emptyLabel.text = "No RSS feed source subscribed"
            } else {
                emptyLabel.text = "No feed available at this moment"
            }
            emptyLabel.textAlignment = NSTextAlignment.Center
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        } else if maxNumOfFeed < feedLoader.feeds.count {
            return maxNumOfFeed
        } else {
            return feedLoader.feeds.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RSSAllCell", forIndexPath: indexPath) as! RSSAllTableViewCell
        if indexPath.row < self.feedLoader.feeds.count {
            cell.feed = self.feedLoader.feeds[indexPath.row]
            cell.load()
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NSLog("You selected cell number: \(indexPath.row)!")
        self.performSegueWithIdentifier("openWebview", sender: self)
    }
    
    func FavorFeed() {
        let alert = UIAlertController(title: "Feed Favored", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    func handleRefresh(refreshControl : UIRefreshControl) {
        mRefreshControl = refreshControl
        feedLoader.load()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "openWebview") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? RSSAllTableViewCell {
                    let webview = segue.destinationViewController as! WebViewController
                    webview.url = cell.link
                }
            }
        }
    }
    
    func longPressReader(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.Began {
            let touchPoint = longPressGestureRecognizer.locationInView(self.view)
            if let indexPath = tableView.indexPathForRowAtPoint(touchPoint) {
                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? RSSAllTableViewCell {
                    FavoriteManager.getInstance().insert(cell.feed!)
                    FavorFeed()
                }
            }
        }
    }
}