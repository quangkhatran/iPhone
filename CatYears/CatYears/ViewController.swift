//
//  ViewController.swift
//  CatYears
//
//  Created by Quang Kha Tran on 15/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var humanYearsTF: UITextField!
    
    @IBOutlet weak var label: UILabel!
    
    
    @IBAction func buttonClicked(_ sender: Any) {
        
        if let humanYears = humanYearsTF.text{
            if var catYears = Int(humanYears){
                catYears *= 7
                label.text = "Your cat is " +  String(catYears) + " years old in Cat Years"
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

