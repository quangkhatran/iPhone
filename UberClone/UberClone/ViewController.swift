//
//  ViewController.swift
//  UberClone
//
//  Created by Quang Kha Tran on 24/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var riderLabel: UILabel!
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var riderDriverSwitch: UISwitch!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var signUpMode = true
    
    @IBAction func topTapped(_ sender: Any) {
       
        if emailTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Missing Information", message: "Please enter your email and password")
        } else {
            
            if let email = emailTextField.text {
                if let password = passwordTextField.text {
                    if signUpMode { // sign up
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                //print("Sign Up Successfully!")
                                if self.riderDriverSwitch.isOn { // driver
                                    let request = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                                    request?.displayName = "Driver"
                                    request?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "driverSegue", sender: nil)
                                } else { // rider
                                    let request = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                                    request?.displayName = "Rider"
                                    request?.commitChanges(completion: nil)
                                    self.performSegue(withIdentifier: "riderSegue", sender: nil)
                                }
                                
                            }
                        })
                    } else { // log in
                        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil {
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                            } else {
                                //print("Log In Successfully!")
                                if user?.displayName == "Driver" { // driver
                                    self.performSegue(withIdentifier: "driverSegue", sender: nil)
                                } else { // rider
                                    self.performSegue(withIdentifier: "riderSegue", sender: nil)
                                }
                                
                            }
                        })
                        
                    }
                }
            }
           
        }
        
    }
    
    func displayAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func bottomTapped(_ sender: Any) {
        if signUpMode {
            topButton.setTitle("Log In", for: .normal)
            bottomButton.setTitle("Sign Up", for: .normal)
            signUpMode = false
            riderLabel.isHidden = true
            driverLabel.isHidden = true
            riderDriverSwitch.isHidden = true
        } else {
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Log In", for: .normal)
            signUpMode = true
            riderLabel.isHidden = false
            driverLabel.isHidden = false
            riderDriverSwitch.isHidden = false
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

