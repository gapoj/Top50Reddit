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
        
        var title:String = ""
        var author:String = ""
        var createdUtc:Int = 0
        var thumbnail:String? = ""
        var numComments:Int = 0
        var visited = false
        var name:String = ""
    }
    var name:String{
        return data.name
    }
    var title:String{
        return data.title
    }
    var author:String{
        return data.author
    }
    var created:String{
        return Date().createdDateDescription(createdUtc: data.createdUtc)
    }
    var thumbnail:String{
        return data.thumbnail ?? ""
    }
    var numComments:Int{
        return data.numComments
    }
    var visited:Bool{
        get{
            return data.visited
        }
        set{
            data.visited = newValue
        }
    }
}

