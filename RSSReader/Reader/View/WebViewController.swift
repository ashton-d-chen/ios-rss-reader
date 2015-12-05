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
        
        let webView:UIWebView = UIWebView(frame: CGRectZero)
        let request = NSURLRequest(URL: NSURL (string: url)!);
        webView.scalesPageToFit = true
        webView.translatesAutoresizingMaskIntoConstraints = false;
        webView.loadRequest(request);
        self.view.addSubview(webView)
        
        NSLayoutConstraint(item: webView,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem:self.view,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1,
            constant: 0).active = true
        
        NSLayoutConstraint(item: webView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem:self.view,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 0).active = true
        
        NSLayoutConstraint(item: self.view,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem:webView,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1,
            constant: 0).active = true
        
        NSLayoutConstraint(item: self.view,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem:webView,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0).active = true
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
