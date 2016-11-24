//
//  PostCell.swift
//  flobi
//
//  Created by Brandon Gregoire on 2016-11-21.
//  Copyright © 2016 brandongregoire. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profieImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likeLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImage.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.image_url)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("BRANDON: Unable to download image from firebase storage")
                } else {
                    print("BRANDON: IMAGE DOWNLOADED FROM STORAGE")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.image_url as NSString)
                            
                            
                        }
                    }
                }
            })
        }
    }
}

