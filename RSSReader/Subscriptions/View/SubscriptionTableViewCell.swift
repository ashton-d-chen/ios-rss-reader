//
//  RSSSubscriptionTableViewCell.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-10-25.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import UIKit

class RSSSubscriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var link: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func remove(sender: UIButton) {
        //let subscription = Subscription()
        //subscription.removeSubscription(self.link)
    }
}
