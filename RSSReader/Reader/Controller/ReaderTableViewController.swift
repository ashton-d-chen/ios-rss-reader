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
        
        self.refreshControl?.addTarget(self, action: #selector(ReaderTableViewController.handleRefresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressReader(longPressGestureRecognizer:)))
        longPressRecognizer.minimumPressDuration = 0.5
        self.view.addGestureRecognizer(longPressRecognizer)
        
        feedLoader.delegate = self
        feedLoader.load()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Image Cache: \(imageCache.count)")
        print("Feed Array: \(feedLoader.feeds.count)")
        
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let defaults:UserDefaults = UserDefaults.standard
        let maxNumOfFeed = defaults.integer(forKey: MAX_NUM_OF_FEED)
        
        if feedLoader.feeds.count == 0{
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            
            let subscriptions : NSMutableArray = SubscriptionManager.getInstance().selectAll()
            if subscriptions.count == 0 {
                emptyLabel.text = "No RSS feed source subscribed"
            } else {
                emptyLabel.text = "No feed available at this moment"
            }
            emptyLabel.textAlignment = NSTextAlignment.center
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        } else if maxNumOfFeed < feedLoader.feeds.count {
            self.tableView.backgroundView = nil
            return maxNumOfFeed
        } else {
            self.tableView.backgroundView = nil
            return feedLoader.feeds.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSSAllCell", for: indexPath) as! RSSAllTableViewCell
        if indexPath.row < self.feedLoader.feeds.count {
            cell.feed = self.feedLoader.feeds[indexPath.row]
            cell.load()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //NSLog("You selected cell number: \(indexPath.row)!")
        self.performSegue(withIdentifier: "openWebview", sender: self)
    }
    
    func FavorFeed() {
        let alert = UIAlertController(title: "Feed Favored", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(alert, animated: true, completion: nil)
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
    
    @objc func handleRefresh(sender : UIRefreshControl) {
        mRefreshControl = sender
        feedLoader.load()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "openWebview") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let cell = self.tableView.cellForRow(at: indexPath) as? RSSAllTableViewCell {
                    let webview = segue.destination as! WebViewController
                    webview.url = cell.link
                }
            }
        }
    }
    
    @objc func longPressReader(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                if let cell = self.tableView.cellForRow(at: indexPath) as? RSSAllTableViewCell {
                    if !FavoriteManager.getInstance().insert(feed: cell.feed!) {
                        print("Insert feed failed")
                    }
                    FavorFeed()
                }
            }
        }
    }
}
