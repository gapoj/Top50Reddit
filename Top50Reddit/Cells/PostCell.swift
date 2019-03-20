//
//  PostCell.swift
//  Top50Reddit
//
//  Created by Guillermo Apoj on 3/19/19.
//  Copyright © 2019 Guillermo Apoj. All rights reserved.
//

import UIKit

protocol PostCellDelegate {
    func dismiss(cell:PostCell)
}
class PostCell: UITableViewCell {
    @IBOutlet weak var readedSignView: UIView!
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var commentsNumberLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    var delegate:PostCellDelegate?
    func configure(withPost post:RedditPost){
        readedSignView.layer.cornerRadius = readedSignView.frame.height/2
        readedSignView.layer.borderWidth = 2
        readedSignView.isHidden = post.visited
        authorLbl.text = post.author
        dateLbl.text = post.created
        if post.numComments == 1{
            commentsNumberLbl.text = "\(post.numComments) comment"
        }else{
            commentsNumberLbl.text = "\(post.numComments) comments"
        }
        titleLbl.text = post.title
        titleLbl.sizeToFit()
        thumbnailImg.load(urlStr: post.thumbnail, successHandler: {})
      
    }
    //MARK: Actions
    @IBAction func dismissAction(_ sender: Any) {
        delegate?.dismiss(cell: self)
    }
    
}
