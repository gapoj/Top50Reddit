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
    @IBOutlet weak var saveImageButton: UIButton!
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = authorLbl {
                label.text = detail.author
            }
            if let img = thumbnailImg{
                img.load(urlStr: detail.thumbnail, successHandler: { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.saveImageButton.isHidden = false
                })
            }
            if let label = titleLbl {
                label.text = detail.title
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveImageButton.isHidden = true
        configureView()
    }
    
    var detailItem: RedditPost?
    {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    // MARK: Actions
    @IBAction func saveAction(_ sender: Any) {
        if let img = thumbnailImg.image{
            UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
}

