//
//  AsynchronouslyLoader.swift
//  RSSReader
//
//  Created by Ashton Chen on 2015-12-04.
//  Copyright © 2015 Ashton Chen. All rights reserved.
//

import Foundation

func getDataFromUrl(myUrl:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Void)) {
    let request = URLRequest(url:myUrl)
    URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
        completion(data, response, error)
        }.resume()
}
