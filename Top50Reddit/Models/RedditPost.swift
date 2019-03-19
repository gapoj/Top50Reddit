//
//  RedditPost.swift
//  Top50Reddit
//
//  Created by Guillermo Apoj on 3/19/19.
//  Copyright © 2019 Guillermo Apoj. All rights reserved.
//

import UIKit

class RedditPost: Codable {
    var data:postData
    struct postData: Codable{
        //I don't know wich of them could be nil so at this stage I put all of them as optionals
        var title:String? = ""
        var author:String? = ""
        var created:Int? = 0
        var thumbnail:String? = ""
        var numComments:Int? = 0
    }
    var title:String{
        return data.title ?? ""
    }
    var author:String{
        return data.author ?? ""
    }
    var created:Int{
        return data.created ?? 0
    }
    var thumbnail:String{
        return data.thumbnail ?? ""
    }
    var numComments:Int{
        return data.numComments ?? 0
    }
}

