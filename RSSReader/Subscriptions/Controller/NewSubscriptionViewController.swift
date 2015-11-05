//
//  NewSubscriptionViewController.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-10-25.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import UIKit
import AVFoundation

class NewSubscriptionViewController: UIViewController {
    @IBOutlet weak var linkTextField: UITextField!
    
    var player : AVAudioPlayer! = nil
    
    required init (coder decoder : NSCoder) {
        //self.subscriptions = Subscriptions.instance
        super.init(coder : decoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let databaseManager = DatabaseManager.init("subscription")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func add(sender: UIButton) {
        if (self.linkTextField.text?.isEmpty == true) {
            Util.invokeAlertMethod("", strBody: "Please enter RSS url.", delegate: nil)
        } else {
            let subscription: Subscription = Subscription()
            subscription.link = self.linkTextField.text!
            let isInserted = ModelManager.getInstance().insert(subscription)
            if isInserted {
                playSound()
                Util.invokeAlertMethod("", strBody: "Record Inserted successfully.", delegate: nil)
            } else {
                Util.invokeAlertMethod("", strBody: "Error in inserting record.", delegate: nil)
            }
        }
        
        // return to previous view
        // display toast message
    }

    func playSound() {
        let path = NSBundle.mainBundle().pathForResource("canary", ofType:"wav")
        let fileURL = NSURL(fileURLWithPath: path!)
        self.player = try? AVAudioPlayer(contentsOfURL: fileURL)
        self.player.volume = 0.1;
        self.player.prepareToPlay()
        //self.player?.delegate = self
        self.player.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
