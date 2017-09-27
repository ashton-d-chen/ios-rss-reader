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
        
        let webView:UIWebView = UIWebView(frame: CGRect.zero)
        let request = URLRequest(url: URL (string: url)! as URL);
        webView.scalesPageToFit = true
        webView.translatesAutoresizingMaskIntoConstraints = false;
        webView.loadRequest(request);
        self.view.addSubview(webView)
        
        NSLayoutConstraint(item: webView,
                           attribute: NSLayoutAttribute.leading,
                           relatedBy: NSLayoutRelation.equal,
                           toItem:self.view,
                           attribute: NSLayoutAttribute.leading,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: webView,
                           attribute: NSLayoutAttribute.top,
                           relatedBy: NSLayoutRelation.equal,
                           toItem:self.view,
                           attribute: NSLayoutAttribute.top,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: self.view,
                           attribute: NSLayoutAttribute.trailing,
                           relatedBy: NSLayoutRelation.equal,
                           toItem:webView,
                           attribute: NSLayoutAttribute.trailing,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        NSLayoutConstraint(item: self.view,
                           attribute: NSLayoutAttribute.bottom,
                           relatedBy: NSLayoutRelation.equal,
                           toItem:webView,
                           attribute: NSLayoutAttribute.bottom,
                           multiplier: 1,
                           constant: 0).isActive = true
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
