//
//  LogInViewController.swift
//  SnapClone
//
//  Created by Quang Kha Tran on 25/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var signUpMode = false
    
    @IBAction func topTapped(_ sender: Any) {
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                if signUpMode {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if let error = error {
                            self.presentAlert(alert: error.localizedDescription)
                        } else {
                            print("Sign Up Successfully")
                            if let user = user {
                            FIRDatabase.database().reference().child("users").child(user.uid).child("email").setValue(user.email)
                            self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                            }
                        }
                    })
                    
                } else {
                    FIRAuth.auth()?.signIn(withEmail: email, password: password
                        , completion: { (user, error) in
                            if let error = error {
                                self.presentAlert(alert: error.localizedDescription)
                            } else {
                                print("Log In Successfully")
                                self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                            }
                    })
                }
            }
        }
        
    }
    
    func presentAlert(alert:String){
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func bottomTapped(_ sender: Any) {
        if signUpMode {
            signUpMode = false
            topButton.setTitle("Log In", for: .normal)
            bottomButton.setTitle("Sign Up", for: .normal)
        } else {
            signUpMode = true
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Log In", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

