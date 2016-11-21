//
//  ViewController.swift
//  flobi
//
//  Created by Brandon Gregoire on 2016-11-17.
//  Copyright © 2016 brandongregoire. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LogInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet var emailField: Fancy_field!

    @IBOutlet var passField: Fancy_field!
    
    @IBAction func facebookbutton(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) {
            (loginResult: FBSDKLoginManagerLoginResult?, error: Error?) in
            if error != nil {
                print("Unable to autheticate to facebook", error!)
                return
            } else {
                print("Successfully autheticated with firebase")
                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credentials)
            }
        }
    }
    
    
    func firebaseAuth(_ credentials: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("BRANDON: Unable to autheticate to firebase")
            } else {
                print("BRANDON: Successfully autheticated with firebase")
            }
        })
    }
    
    @IBAction func SignInBtn(_ sender: Any) {
        if let email = emailField.text, let pwd = passField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("BRANDON: EMAIL user authenticated with firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("BRANDON: Unable to authenticate with firebase using email")
                        } else {
                            print("BRANDON: Successfully autheticated with firebase using email")
                        } // Add different sign in scenarios (Not enough characters in pass etc)    
                    })
                }
            })
        }
    }
    
    
    
    
}

