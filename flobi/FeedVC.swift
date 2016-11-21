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

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func signInTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("BRANDON: ID removed successfully")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToLogIn", sender: nil)
    }
    

}
