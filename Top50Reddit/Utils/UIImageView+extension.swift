//
//  UIImageView+extension.swift
//  Top50Reddit
//
//  Created by Guillermo Apoj on 3/19/19.
//  Copyright © 2019 Guillermo Apoj. All rights reserved.
//

import UIKit
let imageCache = NSCache<NSString, AnyObject>()//so I can cache images
extension UIImageView {
    func load(urlStr: String) {
        if let imageFromCache = imageCache.object(forKey: urlStr as NSString) as? UIImage {
            self.image = imageFromCache
        } else if let url = URL(string: urlStr){
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        imageCache.setObject(image, forKey: urlStr as NSString)
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
}
