//
//  Favorite.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-11-27.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation
import UIKit

class FavoriteTableViewController: UITableViewController {
    
    //var xmlParser : XMLParser!
    
    var feedLoader : FeedLoader = FeedLoader()
    
    var favorites = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(FavoriteTableViewController.handleRefresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favorites = FavoriteManager.getInstance().selectAll()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.favorites.count == 0{
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No favored feed"
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            return 0
        } else {
            self.tableView.backgroundView = nil
            return self.favorites.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSSFavoriteCell", for: indexPath) as! RSSAllTableViewCell
        if indexPath.row < self.favorites.count {
            cell.feed = self.favorites.object(at: indexPath.row) as? Feed
            cell.load()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //NSLog("You selected cell number: \(indexPath.row)!")
        self.performSegue(withIdentifier: "openFavoriteWebview", sender: self)
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
    
    func removeFavorite(feed : Feed) {
        let refreshAlert = UIAlertController(title: "Remove Favorite", message: "Are you sure you want to unfavor this RSS feed?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if !FavoriteManager.getInstance().remove(feed: feed) {
                
            }
            self.favorites = FavoriteManager.getInstance().selectAll()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            //println("Handle Cancel Logic here")
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @objc func handleRefresh(sender : UIRefreshControl) {
        sender.endRefreshing()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openFavoriteWebview") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let cell = self.tableView.cellForRow(at: indexPath) as? RSSAllTableViewCell {
                    let webview = segue.destination as! WebViewController
                    webview.url = cell.link
                }
            }
        }
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                if let cell = self.tableView.cellForRow(at: indexPath) as? RSSAllTableViewCell {
                    removeFavorite(feed: cell.feed!)
                }
            }
        }
    }
}
