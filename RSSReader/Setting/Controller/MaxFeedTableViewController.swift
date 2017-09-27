//
//  MaxFeedTableViewController.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-12-05.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import UIKit

class MaxFeedTableViewController: UITableViewController {
    @IBOutlet weak var maxThirtyCell: UIButton!
    @IBOutlet weak var maxSixtyCell: UIButton!
    @IBOutlet weak var maxHundredCell: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.maxThirtyCell?.addTarget(self, action: #selector(maxThirtyFeeds(sender:)), for: UIControlEvents.touchUpInside)
        self.maxSixtyCell?.addTarget(self, action: #selector(maxThirtyFeeds(sender:)), for: UIControlEvents.touchUpInside)
        self.maxHundredCell?.addTarget(self, action: #selector(maxThirtyFeeds(sender:)), for: UIControlEvents.touchUpInside)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return 4
    }
    
    @IBAction func maxThirtyFeeds(sender: UIButton) {
        setMaxNumOfFeed(number: 30)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func maxSixtyFeeds(sender: UIButton) {
        setMaxNumOfFeed(number: 60)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func maxHundredFeeds(sender: UIButton) {
        setMaxNumOfFeed(number: 100)
        navigationController?.popViewController(animated: true)
    }
    
    func setMaxNumOfFeed(number : Int) {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: MAX_NUM_OF_FEED) as? String == nil {
            defaults.set("30", forKey: MAX_NUM_OF_FEED)
        } else {
            defaults.set(String(number), forKey: MAX_NUM_OF_FEED)
        }
    }
    
    /*
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
