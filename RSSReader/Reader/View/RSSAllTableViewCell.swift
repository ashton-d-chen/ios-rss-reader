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

let CELL_MARGIN : CGFloat = 5

let LEADING_MARGIN : CGFloat = CELL_MARGIN
let TOP_MARGIN : CGFloat = CELL_MARGIN
let TRAILING_MARGIN : CGFloat = CELL_MARGIN
let BOTTOM_MARGIN : CGFloat = CELL_MARGIN

let CELL_HEIGHT : CGFloat = 80

let TITLE_FONT_SIZE : CGFloat = 13
let SUMMARY_FONT_SIZE : CGFloat = 12


class RSSAllTableViewCell: UITableViewCell {
    var thumbnail : UIImageView!
    var title : UILabel!
    var summary : UILabel!
    var link : String = ""
    let padding: CGFloat = 5
    var feed : Feed?
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        
        self.thumbnail = UIImageView(frame: CGRect(x: 0,y: 0,width: THUMBNAIL_WIDTH, height: THUMBNAIL_HEIGHT))
        self.thumbnail.translatesAutoresizingMaskIntoConstraints = false
        self.thumbnail.contentMode = UIViewContentMode.scaleAspectFit
        self.thumbnail.widthAnchor.constraint(equalToConstant: THUMBNAIL_WIDTH).isActive = true
        
        self.title = UILabel(frame: CGRect.zero)
        self.title.translatesAutoresizingMaskIntoConstraints = true
        self.title.font = UIFont(name:"HelveticaNeue-Bold", size: TITLE_FONT_SIZE)
        
        self.title.textColor = UIColor.black
        self.title.numberOfLines = 0
        self.title.sizeToFit()
        
        //self.title.backgroundColor = UIColor.redColor()
        self.title.lineBreakMode = NSLineBreakMode.byTruncatingTail
        self.title.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: UILayoutConstraintAxis.vertical)
        
        
        self.summary = UILabel(frame: CGRect.zero)
        self.summary.translatesAutoresizingMaskIntoConstraints = true
        self.summary.font = UIFont.systemFont(ofSize: SUMMARY_FONT_SIZE)
        self.summary.textColor = UIColor.black
        self.summary.numberOfLines = 3
        self.summary.sizeToFit()
        //self.summary.backgroundColor = UIColor.greenColor()
        self.summary.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        
        // Text Stack View
        let textStackView   = UIStackView()
        textStackView.axis  = UILayoutConstraintAxis.vertical
        textStackView.distribution  = UIStackViewDistribution.fillProportionally
        textStackView.alignment = UIStackViewAlignment.top
        textStackView.spacing = 0
        textStackView.addArrangedSubview(self.title)
        textStackView.addArrangedSubview(self.summary)
        textStackView.translatesAutoresizingMaskIntoConstraints = false;
        /*
         NSLayoutConstraint(item: self.title,
         attribute: NSLayoutAttribute.Top,
         relatedBy: NSLayoutRelation.Equal,
         toItem:textStackView,
         attribute: NSLayoutAttribute.Top,
         multiplier: 1,
         constant: TOP_MARGIN).active = true
         
         NSLayoutConstraint(item: textStackView,
         attribute: NSLayoutAttribute.Bottom,
         relatedBy: NSLayoutRelation.Equal,
         toItem: self.summary,
         attribute: NSLayoutAttribute.Bottom,
         multiplier: 1,
         constant: BOTTOM_MARGIN).active = true
         */
        // Cell Stack View
        let cellStackView   = UIStackView()
        cellStackView.axis  = UILayoutConstraintAxis.horizontal
        cellStackView.alignment = UIStackViewAlignment.fill
        cellStackView.spacing   = 8.0
        cellStackView.addArrangedSubview(self.thumbnail!)
        cellStackView.addArrangedSubview(textStackView)
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
                    loadImage(imageURL: feed!.postImage, shouldCrop: true)
                } else {
                    DispatchQueue.main.async {
                        self.thumbnail!.image = image
                    }
                }
            } else if feed!.rssImage.characters.count > 0 {
                let image = imageCache[self.feed!.rssImage]
                if  image == nil {
                    loadImage(imageURL: feed!.rssImage, shouldCrop: false)
                } else {
                    DispatchQueue.main.async {
                        self.thumbnail!.image = image
                    }
                }
            } else {
                self.thumbnail!.image = UIImage(named:"DefaultThumbnail.png")
            }
            
            if let link : String = feed?.postLink {
                self.link = link
            }
        }
    }
    
    func loadImage(imageURL: String, shouldCrop: Bool) {
        let imgURL: URL = URL(string: imageURL)!
        getDataFromUrl(myUrl: imgURL, completion: {(data, response, error) in
            if error == nil {
                var image = UIImage(data: data! as Data)
                if image != nil {
                    if (shouldCrop) {
                        image = SquareImage(image: image!)
                    }
                    imageCache[self.feed!.postImage] = image
                    DispatchQueue.main.async {
                        self.thumbnail!.image = image
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //titleLabel.frame = CGRectMake(padding, (frame.height - 25)/2, 40, 25)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
