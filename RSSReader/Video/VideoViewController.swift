//
//  VideoViewController.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-11-04.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {
    
    var player : AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let path = NSBundle.mainBundle().pathForResource("intro", ofType:"mp4")
        let url = NSURL.fileURLWithPath(path!)
        let item = AVPlayerItem(URL: url)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: item)
        self.player = AVPlayer(playerItem: item)
        let playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.backgroundColor = UIColor.blackColor().CGColor
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        self.player.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        self.player.pause()
        self.player = nil
        performSegueWithIdentifier("showMainView", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showMainView") {
           /* if let vc = segue.destinationViewController as? SecondView {
                let text = self.input.text
                vc.data = text
            }*/
        }
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        self.player.pause()
        self.player = nil
        performSegueWithIdentifier("showMainView", sender: self)
    }
}
