//
//  WebViewController.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-11-07.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    //@IBOutlet weak var webview: UIWebView!
    var url : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webView:UIWebView = UIWebView(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        let request = NSURLRequest(URL: NSURL (string: url)!);
        webView.scalesPageToFit = true
        webView.loadRequest(request);
        //webView.delegate = self
        self.view.addSubview(webView)
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
