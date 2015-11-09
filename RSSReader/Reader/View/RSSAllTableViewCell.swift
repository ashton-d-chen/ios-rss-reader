//
//  RSSAllTableViewCell.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-10-25.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import UIKit

class RSSAllTableViewCell: UITableViewCell {

    var thumbnail : UIImageView?
    var title : UILabel!
    var summary : UILabel!
    var link : String = ""
    let padding: CGFloat = 5
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        
        self.thumbnail = UIImageView(frame: CGRect(x: 0,y: 0,width: 100,height: 100))
        self.thumbnail?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(thumbnail!)
   
        // following does not work
        let thumbnailLeadingConstraint = NSLayoutConstraint(item: self.thumbnail!,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem:self,
            attribute: NSLayoutAttribute.LeadingMargin,
            multiplier: 1,
            constant: 0)
        NSLayoutConstraint.activateConstraints([thumbnailLeadingConstraint])
        
        self.title = UILabel(frame: CGRectZero)
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.title.font = UIFont.systemFontOfSize(16)
        self.title.textColor = UIColor.blackColor()
        self.contentView.addSubview(self.title)
        
        let titleTopConstraint = NSLayoutConstraint(item: self.title,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem:self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1,
            constant: 5)
        
        let titleLeadingConstraint = NSLayoutConstraint(item: self.title,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem:self.thumbnail,
            attribute: NSLayoutAttribute.LeadingMargin,
            multiplier: 1,
            constant: 110)
        
        NSLayoutConstraint.activateConstraints([titleTopConstraint, titleLeadingConstraint])

        
        self.summary = UILabel(frame: CGRectZero)
        self.summary.translatesAutoresizingMaskIntoConstraints = false
        self.summary.font = UIFont.systemFontOfSize(13)
        self.summary.textColor = UIColor.blackColor()
        self.summary.numberOfLines = 3
        self.summary.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.contentView.addSubview(self.summary)
        
        let summaryTopConstraint = NSLayoutConstraint(item: self.summary,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem:self.title,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 1)
        
        let summaryLeadingConstraint = NSLayoutConstraint(item: self.summary,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem:self.thumbnail,
            attribute: NSLayoutAttribute.LeadingMargin,
            multiplier: 1,
            constant: 110)

        let summaryTrailingConstraint = NSLayoutConstraint(item: self.summary,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem:self,
            attribute: NSLayoutAttribute.TrailingMargin,
            multiplier: 1,
            constant: 0)
        
        NSLayoutConstraint.activateConstraints([summaryTopConstraint, summaryLeadingConstraint, summaryTrailingConstraint])
        
        /*
        // trailing margin constraint
        let const1 = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.TrailingMargin, relatedBy: NSLayoutRelation.Equal, toItem: self.title, attribute: NSLayoutAttribute.TrailingMargin, multiplier: 1, constant: 0)
        // top constraint
        let const2 = NSLayoutConstraint(item: self.title, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        // bottom constraint
        let const3 = NSLayoutConstraint(item: bottomLayoutGuide, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.title, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        // leading margin constraint
        let const4 = NSLayoutConstraint(item: self.title, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem:self, attribute: NSLayoutAttribute.LeadingMargin, multiplier: 1, constant: 0)
        */
        
        /*
        let horizontalConstraint = title.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let vertivalConstraint = title.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor)
        let widthConstraint = title.widthAnchor.constraintEqualToAnchor(nil, constant: 100)
        let heightConstraint = title.heightAnchor.constraintEqualToAnchor(nil, constant: 100)
        NSLayoutConstraint.activateConstraints([horizontalConstraint, vertivalConstraint, widthConstraint, heightConstraint])
        */
        

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //titleLabel.frame = CGRectMake(padding, (frame.height - 25)/2, 40, 25)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
