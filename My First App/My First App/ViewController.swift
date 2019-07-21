//
//  ViewController.swift
//  My First App
//
//  Created by Quang Kha Tran on 14/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var textField: UITextField!
    @IBAction func ButtonClicked(_ sender: Any) {
            print("Button clicked")
        if let name = textField.text{
            if let age = ageTextField.text{
            label.text = "Hello " + name + " and you are " + age + " years old"
            }
            
        }
    }
    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Hello")
    }


}

