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
    @IBOutlet weak var AddButton: UIButton!
    
    var player : AVAudioPlayer! = nil
    
    required init (coder decoder : NSCoder) {
        //self.subscriptions = Subscriptions.instance
        super.init(coder : decoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddButton.addTarget(self, action: #selector(NewSubscriptionViewController.addNewSubscription(_:)), for: .touchUpInside)
        //let databaseManager = DatabaseManager.init("subscription")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addNewSubscription(_ sender: UIButton) {
        //print(self.linkTextField.text!.characters.count)
        let rssSource:String = self.linkTextField.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        addSubscription(rssSource)
    }
    
    func addSubscription(_ rssSource: String) {
        if (rssSource.characters.count == 0) {
            let alert = UIAlertController(title: "Invalid RSS URL", message: "Please enter a valid RSS URL.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                // Insert action
            }))
            
            present(alert, animated: true, completion: nil)
        } else {
            let xmlParser = SubscriptionXMLParser()
            xmlParser.delegate = self
            xmlParser.query(rssURL: rssSource)
        }
    }
    
    func subscriptionParsed(subscription : Subscription) {
        if !SubscriptionManager.getInstance().insert(subscription: subscription) {
            print("Insert subscription failed")
        }
        // return to previous view
        navigationController?.popViewController(animated: true)
    }
    
    func parsingError() {
        let alert = UIAlertController(title: "Invalid RSS URL", message: "Please enter a valid RSS URL.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            // Insert action
        }))
        present(alert, animated: true, completion: nil)
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
