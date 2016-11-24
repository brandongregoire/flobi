//
//  FeedVC.swift
//  flobi
//
//  Created by Brandon Gregoire on 2016-11-20.
//  Copyright © 2016 brandongregoire. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var captionField: Fancy_field!
    @IBOutlet var addImage: CircleView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imgSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true 
        imagePicker.delegate = self
        
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let id = snap.key
                        let post = Post(postId: id, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            if let img = FeedVC.imageCache.object(forKey: post.image_url as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return PostCell()
        }
    }
    
    // Gets rid of image selector once an image is selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImage.image = image
            imgSelected = true
        } else {
            print("BRANDON: A Valid image was not selected")        
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("BRANDON: Caption must be entered")
            return 
        }
        guard let img = addImage.image, imgSelected == true else {
            print("BRANDON: A image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("BRANDON: Unable to upload image to firebase storage")
                } else {
                    print("BRANDON: Successfully uplaoded image to firebase sotrage")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
            
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
            "caption": captionField.text as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "likes": 0 as AnyObject
        ]
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imgSelected = false
        addImage.image = UIImage(named: "add-image")
        
        self.posts.reverse()
        tableView.reloadData()
        
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
    present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("BRANDON: ID removed successfully")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToLogIn", sender: nil)
    }
    
    

}
