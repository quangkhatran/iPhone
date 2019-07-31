//
//  ViewController.swift
//  FBLogIn
//
//  Created by Quang Kha Tran on 31/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class ViewController: UIViewController, LoginButtonDelegate {
    
    /*
     @objc
     func loginButtonClicked() {
     let loginManager = LoginManager()
     loginManager.logIn(permissions: [ .publicProfile ], viewController: self) { loginResult in
     switch loginResult {
     case .failed(let error):
     print(error)
     case .cancelled:
     print("User cancelled login.")
     case .success(let grantedPermissions, let declinedPermissions, let accessToken):
     print("Logged in!")
     }
     }
     }
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Add a custom login button to your app
        /*
         let myLoginButton = UIButton(type: .custom)
         myLoginButton.backgroundColor = UIColor.darkGray
         myLoginButton.frame = CGRect(x: 0, y: 0, width: 180, height: 40);
         myLoginButton.center = view.center;
         myLoginButton.setTitle("My Login Button", for: .normal)
         myLoginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
         view.addSubview(myLoginButton)
         */
        let loginButton = FBLoginButton(frame: CGRect(x: 0, y: 0, width: 250, height: 40), permissions: [.publicProfile, .email, .userFriends])
        loginButton.center = view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
        if let accessToken = AccessToken.current {
            // User is already logged in with Facebook
            print("User is already logged in")
            print(accessToken)
        }
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("User logged in")
        print(result?.grantedPermissions)
        if error != nil {
            print(error!)
        } else if let cancelled = result?.isCancelled {
            if cancelled {
                print("User has cancelled log in")
            }
            else {
                if let permissions = result?.grantedPermissions {
                    if permissions.contains("email"){
                        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "email,name"])
                        graphRequest.start { (connection, result, error) in
                            if error != nil {
                                print(error!)
                            } else {
                                if let result = result {
                                    print(result)
                                }
                            }
                        }
                        
                    }
                }
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Log Out")
    }
    
    
}

