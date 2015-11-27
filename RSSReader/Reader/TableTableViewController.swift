//
//  TableTableViewController.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-11-06.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation
import UIKit

class TableTableViewController: UITableViewController, FeedLoadingDelegate {

    //var xmlParser : XMLParser!
    
    var feedLoader : FeedLoader = FeedLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    
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
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedLoader.feeds.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RSSAllCell", forIndexPath: indexPath) as! RSSAllTableViewCell

        cell.feed = self.feedLoader.feeds[indexPath.row]
        cell.load()
        /*if let url = NSURL(string : currentDictionary["media:thumbnail"]!) {
            print ("success")
            /*if let imageURL = NSBundle.mainBundle().URLForResource("imageName", withExtension: "jpg"), let data = NSData(contentsOfURL: url), let image = UIImage(data: data) {
                cell.thumbnail.contentMode = .ScaleAspectFit
                cell.thumbnail.image = image
            }*/
        }*/
/*
        if let title : String = feed.postTitle {
        var label = UILabel(frame: CGRectMake(0, 14.0, 100.0, 30.0))
            label.text = title.trunc(30)
            label.tag = indexPath.row
            cell.contentView.addSubview(label)
        }
*/
 

        
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NSLog("You selected cell number: \(indexPath.row)!")
        self.performSegueWithIdentifier("openWebview", sender: self)
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
        feedLoader.load()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
 /*
        if segue.identifier == "openWebview" {
            if let destination = segue.destinationViewController as? WebViewController {
                if let index = tableView.indexPathForSelectedRow {
                    destination.url = xmlParser.feeds[index].link
                }
            }
        }
*/
        if (segue.identifier == "openWebview") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? RSSAllTableViewCell {
                    let webview = segue.destinationViewController as! WebViewController
                    webview.url = cell.link
                }
            }
        }
    }
}