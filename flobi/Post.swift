//
//  Post.swift
//  flobi
//
//  Created by Brandon Gregoire on 2016-11-23.
//  Copyright © 2016 brandongregoire. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _caption: String!
    private var _image_url: String!
    private var _likes: Int!
    private var _postId: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var image_url: String {
        return _image_url
    }
    
    var likes: Int {
        return _likes
    }
    
    var postId: String {
        return _postId
    }
    
    init(caption: String, image_url: String, likes: Int) {
        self._caption = caption
        self._image_url = image_url
        self._likes = likes
    }
    
    init(postId: String, postData: Dictionary<String, AnyObject>) {
        self._postId = postId
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let image_url = postData["imageUrl"] as? String {
            self._image_url = image_url
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postId)
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
}
