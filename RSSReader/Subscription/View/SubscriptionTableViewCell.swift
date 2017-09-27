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
        
        thumbnailImage = UIImageView(frame: CGRect.zero)
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImage.contentMode = UIViewContentMode.scaleAspectFit
        thumbnailImage.widthAnchor.constraint(equalToConstant: THUMBNAIL_WIDTH).isActive = true
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: TITLE_FONT_SIZE)
        titleLabel.textColor = UIColor.black
        titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        titleLabel.numberOfLines = 0
        //titleLabel.setContentCompressionResistancePriority(950, forAxis: UILayoutConstraintAxis.Horizontal)
        
        
        let removeButton = UIButton(type: UIButtonType.system)
        removeButton.frame = CGRect.zero
        removeButton.sizeToFit()
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.setTitle("Remove", for: [])
        removeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right;
        removeButton.addTarget(self, action: Selector("remove:"), for: UIControlEvents.touchUpInside)
        
        // Cell Stack View
        let cellStackView   = UIStackView()
        cellStackView.axis  = UILayoutConstraintAxis.horizontal
        cellStackView.alignment = UIStackViewAlignment.fill
        cellStackView.spacing   = 8.0
        cellStackView.addArrangedSubview(thumbnailImage)
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(cellStackView)
        
        NSLayoutConstraint(item: cellStackView,
                           attribute: NSLayoutAttribute.leading,
                           relatedBy: NSLayoutRelation.equal,
                           toItem:self,
                           attribute: NSLayoutAttribute.leading,
                           multiplier: 1,
                           constant: LEADING_MARGIN).isActive = true
        
        NSLayoutConstraint(item: cellStackView,
                           attribute: NSLayoutAttribute.top,
                           relatedBy: NSLayoutRelation.equal,
                           toItem:self,
                           attribute: NSLayoutAttribute.top,
                           multiplier: 1,
                           constant: TOP_MARGIN).isActive = true
        
        NSLayoutConstraint(item: self,
                           attribute: NSLayoutAttribute.trailing,
                           relatedBy: NSLayoutRelation.equal,
                           toItem:cellStackView,
                           attribute: NSLayoutAttribute.trailing,
                           multiplier: 1,
                           constant: TRAILING_MARGIN).isActive = true
        
        NSLayoutConstraint(item: self,
                           attribute: NSLayoutAttribute.bottom,
                           relatedBy: NSLayoutRelation.equal,
                           toItem:cellStackView,
                           attribute: NSLayoutAttribute.bottom,
                           multiplier: 1,
                           constant: BOTTOM_MARGIN).isActive = true
    }
    
    func load() {
        if self.subscription != nil {
            if self.subscription!.rssImageURL.characters.count > 0 {
                let image = imageCache[self.subscription!.rssImageURL]
                
                if image == nil {
                    loadImage(imageURL: self.subscription!.rssImageURL, shouldCrop: false)
                } else {
                    DispatchQueue.main.async {
                        self.thumbnailImage.image = image
                    }
                }
            } else {
                self.thumbnailImage.image = UIImage(named:"DefaultThumbnail.png")
            }
            
            titleLabel.text = self.subscription!.rssTitle
        }
    }
    
    func loadImage(imageURL: String, shouldCrop: Bool) {
        let imgURL: URL = URL(string: imageURL)!
        getDataFromUrl(myUrl: imgURL, completion: {(data, response, error) in
            if error == nil {
                var image = UIImage(data: data!)
                if image != nil {
                    if (shouldCrop) {
                        image = SquareImage(image: image!)
                    }
                    imageCache[self.subscription!.rssImageURL] = image
                    DispatchQueue.main.async {
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func remove(sender: UIButton) {
        //print("remove subscription")
        self.viewController.removeSubscription(subscription: self.subscription!)
    }
}
