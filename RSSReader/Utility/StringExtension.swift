//
//  StringExtension.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-11-06.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation

extension String {
    func trunc(length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}