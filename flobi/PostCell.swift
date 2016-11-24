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
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    var likesref: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true 
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likesref = DataService.ds.REF_CURRENT_USER.child("likes").child(post.postId)
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
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesref.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesref.removeValue()
            }
        })
    }
}

