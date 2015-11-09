//
//  WebViewController.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-11-07.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet weak var webview: UIWebView!
    var url : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(url)
        let requestObj = NSURLRequest(URL: NSURL (string: url)!);
        webview.loadRequest(requestObj);
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
