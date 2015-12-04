//
//  RSSAllTableViewCell.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-10-25.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import UIKit

let THUMBNAIL_WIDTH : CGFloat = 70
let THUMBNAIL_HEIGHT : CGFloat = THUMBNAIL_WIDTH
let THUMBNAIL_SIZE : CGSize = CGSize(width: THUMBNAIL_WIDTH, height: THUMBNAIL_HEIGHT)

let CELL_MARGIN : CGFloat = 8

let LEADING_MARGIN : CGFloat = CELL_MARGIN
let TOP_MARGIN : CGFloat = CELL_MARGIN
let TRAILING_MARGIN : CGFloat = CELL_MARGIN
let BOTTOM_MARGIN : CGFloat = CELL_MARGIN

let CELL_HEIGHT : CGFloat = 100

let TITLE_FONT_SIZE : CGFloat = 14
let SUMMARY_FONT_SIZE : CGFloat = 12


class RSSAllTableViewCell: UITableViewCell {
    var thumbnail : UIImageView?
    var title : UILabel!
    var summary : UILabel!
    var link : String = ""
    let padding: CGFloat = 5
    var feed : Feed?
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        
        self.thumbnail = UIImageView(frame: CGRect(x: 0,y: 0,width: THUMBNAIL_WIDTH, height: THUMBNAIL_HEIGHT))
        self.thumbnail!.translatesAutoresizingMaskIntoConstraints = false
        self.thumbnail!.contentMode = UIViewContentMode.ScaleAspectFit
        self.thumbnail!.widthAnchor.constraintEqualToConstant(THUMBNAIL_WIDTH).active = true
        
        self.title = UILabel(frame: CGRectZero)
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.title.font = UIFont.systemFontOfSize(TITLE_FONT_SIZE)
        self.title.textColor = UIColor.blackColor()
        self.title.numberOfLines = 2
        self.title.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        self.summary = UILabel(frame: CGRectZero)
        self.summary.translatesAutoresizingMaskIntoConstraints = false
        self.summary.font = UIFont.systemFontOfSize(SUMMARY_FONT_SIZE)
        self.summary.textColor = UIColor.blackColor()
        self.summary.numberOfLines = 3
        self.summary.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        // Text Stack View
        let textStackView   = UIStackView()
        textStackView.axis  = UILayoutConstraintAxis.Vertical
        textStackView.distribution  = UIStackViewDistribution.EqualSpacing
        textStackView.alignment = UIStackViewAlignment.Leading
        textStackView.spacing   = 1.0
        textStackView.addArrangedSubview(self.title)
        textStackView.addArrangedSubview(self.summary)
        textStackView.translatesAutoresizingMaskIntoConstraints = false;
        
        // Cell Stack View
        let cellStackView   = UIStackView()
        cellStackView.axis  = UILayoutConstraintAxis.Horizontal
        cellStackView.alignment = UIStackViewAlignment.Fill
        cellStackView.spacing   = 8.0
        cellStackView.addArrangedSubview(self.thumbnail!)
        cellStackView.addArrangedSubview(textStackView)
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
        if feed != nil {
            if let title : String = feed!.postTitle {
                self.title!.text = title
            }
            
            if let description : String = feed!.postDescription {
                self.summary!.text = description
            }
            
            if feed!.postImage.characters.count > 0 {
                let image = imageCache[self.feed!.postImage]
                
                if image == nil {
                    loadImage(feed!.postImage, shouldCrop: true)
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.thumbnail!.image = image
                    })
                }
            } else if feed!.rssImage.characters.count > 0 {
                let image = imageCache[self.feed!.rssImage]
                if  image == nil {
                    loadImage(feed!.rssImage, shouldCrop: false)
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.thumbnail!.image = image
                    })
                }
            } else {
                self.thumbnail!.image = UIImage(named:"DefaultThumbnail.png")
            }
            
            if let link : String = feed!.postLink {
                self.link = link
            }
        }
    }
    
    func loadImage(imageURL: String, shouldCrop: Bool) {
        let imgURL: NSURL = NSURL(string: imageURL)!
        
        // Download an NSData representation of the image at the URL
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ response, data, error in
            if error == nil {
                var image = UIImage(data: data!)
                if (shouldCrop) {
                    image = SquareImage(image!)
                }
                // Store the image in to our cache
                imageCache[self.feed!.postImage] = image
                //                            imageCache[self.feed!.postImage] = ResizeImage(image!, targetSize: THUMBNAIL_SIZE)
                self.thumbnail!.image = image
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        })

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
