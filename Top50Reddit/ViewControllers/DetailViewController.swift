//
//  DetailViewController.swift
//  Top50Reddit
//
//  Created by Guillermo Apoj on 3/19/19.
//  Copyright © 2019 Guillermo Apoj. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = authorLbl {
                label.text = detail.author
            }
            if let img = thumbnailImg{
                img.load(urlStr: detail.thumbnail)
            }
            if let label = titleLbl {
                label.text = detail.title
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    var detailItem: RedditPost?
    {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

