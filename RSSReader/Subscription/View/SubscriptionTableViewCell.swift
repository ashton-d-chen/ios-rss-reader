//
//  RSSSubscriptionTableViewCell.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-10-25.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {
    @IBOutlet weak var link: UILabel!
    
    var subscription : Subscription?
    var viewController : SubscriptionTableViewController!
    
    var thumbnailImage: UIImageView!
    var titleLabel: UILabel!
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        
        thumbnailImage = UIImageView(frame: CGRectZero)
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImage.contentMode = UIViewContentMode.ScaleAspectFit
        thumbnailImage.widthAnchor.constraintEqualToConstant(THUMBNAIL_WIDTH).active = true
        
        titleLabel = UILabel(frame: CGRectZero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFontOfSize(TITLE_FONT_SIZE)
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        titleLabel.numberOfLines = 0
        //titleLabel.setContentCompressionResistancePriority(950, forAxis: UILayoutConstraintAxis.Horizontal)

        
        let removeButton = UIButton(type: UIButtonType.System)
        removeButton.frame = CGRectZero
        removeButton.sizeToFit()
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.setTitle("Remove", forState: UIControlState.Normal)
        removeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right;
        removeButton.addTarget(self, action: "remove:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Cell Stack View
        let cellStackView   = UIStackView()
        cellStackView.axis  = UILayoutConstraintAxis.Horizontal
        cellStackView.alignment = UIStackViewAlignment.Fill
        cellStackView.spacing   = 8.0
        cellStackView.addArrangedSubview(thumbnailImage)
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(cellStackView)

        NSLayoutConstraint(item: cellStackView,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem:self,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1,
            constant: LEADING_MARGIN).active = true
        
        NSLayoutConstraint(item: cellStackView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem:self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: TOP_MARGIN).active = true
        
        NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem:cellStackView,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1,
            constant: TRAILING_MARGIN).active = true
        
        NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem:cellStackView,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: BOTTOM_MARGIN).active = true
    }
    
    func load() {
        if self.subscription != nil {
            if self.subscription!.rssImageURL.characters.count > 0 {
                let image = imageCache[self.subscription!.rssImageURL]
                
                if image == nil {
                    loadImage(self.subscription!.rssImageURL, shouldCrop: false)
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.thumbnailImage.image = image
                    })
                }
            } else {
                self.thumbnailImage.image = UIImage(named:"DefaultThumbnail.png")
            }
            
            titleLabel.text = self.subscription!.rssTitle
        }
    }
    
    func loadImage(imageURL: String, shouldCrop: Bool) {
        let imgURL: NSURL = NSURL(string: imageURL)!
        getDataFromUrl(imgURL, completion: {(data, response, error) in
            if error == nil {
                var image = UIImage(data: data!)
                if image != nil {
                    if (shouldCrop) {
                        image = SquareImage(image!)
                    }
                    imageCache[self.subscription!.rssImageURL] = image
                    dispatch_async(dispatch_get_main_queue()) {
                        self.thumbnailImage.image = image
                    }
                }
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func remove(sender: UIButton) {
        //print("remove subscription")
        self.viewController.removeSubscription(self.subscription!)
    }
}
