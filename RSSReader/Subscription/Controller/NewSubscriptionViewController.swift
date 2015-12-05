//
//  NewSubscriptionViewController.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-10-25.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import UIKit
import AVFoundation

class NewSubscriptionViewController: UIViewController, SubscriptionXMLParserDelegate {
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
        //print(self.linkTextField.text!.characters.count)
        if (self.linkTextField.text!.characters.count == 0) {
            let alert = UIAlertController(title: "Invalid RSS link", message: "Please enter a valid RSS link.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                // Insert action
            }))
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            let xmlParser = SubscriptionXMLParser()
            xmlParser.delegate = self
            xmlParser.query(self.linkTextField.text!)
        }
    }
    
    func subscriptionParsed(subscription : Subscription) {
        ModelManager.getInstance().insert(subscription)
        // return to previous view
        navigationController?.popViewControllerAnimated(true)

    }
    
    func parsingError() {
        
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
