//
//  ListingResponse.swift
//  Top50Reddit
//
//  Created by Guillermo Apoj on 3/19/19.
//  Copyright © 2019 Guillermo Apoj. All rights reserved.
//

import UIKit

class ListingResponse: Codable {
    var data: ListingData
    struct ListingData: Codable{
        var before:String?
        var after:String?
        var dist:Int = 0
        var children = [RedditPost]()
    }
    var posts: [RedditPost]{
        return data.children
    }
}
