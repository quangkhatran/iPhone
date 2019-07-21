//
//  ViewController.swift
//  InstagramClone
//
//  Created by Quang Kha Tran on 20/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    var signupModeActive = true
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var signupOrLoginButton: UIButton!
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            self.dismiss(animated: true
                , completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func signupOrLogin(_ sender: Any) {
        if email.text == "" || password.text == "" {
            displayAlert(title:"Error in form", message:"Please enter an email and password")
        } else {
            
            // show Spinner while waiting for Sign Up/Log In
            let activityIndicator = UIActivityIndicatorView(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            
            if signupModeActive { // sign up
                let user = PFUser()
                user.username = email.text
                user.password = password.text
                user.email = email.text
                
                user.signUpInBackground {
                    (success, error) in
                    
                    // stop Spinner
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if let error = error {
                        self.displayAlert(title: "Could not sign you up", message: error.localizedDescription)
                    } else {
                        print("Signed up!")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                }
            } else { // log in
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!) { (user, error) in
                    
                    // stop Spinner
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if user != nil {
                        print("Log In Successfully!")
                        self.performSegue(withIdentifier: "showUserTable", sender: self)

                    } else {
                        // The login failed. Check error to see why.
                        if let error = error {
                            self.displayAlert(title: "Could not log in", message: error.localizedDescription)
                        }
                    }
                }
                
            }
        }
    }
    
    @IBOutlet weak var switchLoginModeButton: UIButton!
    
    
    @IBAction func switchLoginMode(_ sender: Any) {
        if(signupModeActive){
            signupModeActive = false
            signupOrLoginButton.setTitle("Log In", for: [])
            switchLoginModeButton.setTitle("Sign Up", for: [])
        } else {
            signupModeActive = true
            signupOrLoginButton.setTitle("Sign Up", for: [])
            switchLoginModeButton.setTitle("Log In", for: [])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true 

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

