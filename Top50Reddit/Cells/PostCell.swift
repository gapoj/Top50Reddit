//
//  PostCell.swift
//  Top50Reddit
//
//  Created by Guillermo Apoj on 3/19/19.
//  Copyright © 2019 Guillermo Apoj. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var readedSignView: UIView!
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var commentsNumberLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBAction func dismissAction(_ sender: Any) {
    }
}
