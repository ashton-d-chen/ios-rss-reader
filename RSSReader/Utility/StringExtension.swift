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
            let index: String.Index = self.index(self.startIndex, offsetBy: length)
            return self.substring(to: index) + (trailing ?? "")
        } else {
            return self
        }
    }
}
