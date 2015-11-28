//
//  Feed.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-11-06.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation
import UIKit

var imageCache = [String : UIImage]()

class Feed {
    var id : String = String()
    var postGuid: String = String()
    var postTitle: String = String()
    var postLink: String = String()
    var postImage: String = String()
    var postDescription: String = String()
    var postPubDate = String()
}