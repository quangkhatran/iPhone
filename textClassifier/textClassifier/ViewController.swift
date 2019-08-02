//
//  ViewController.swift
//  TextClassifier
//
//  Created by Quang Kha Tran on 02/08/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        answerLabel.text = ""
    }
    
    @IBAction func classifyTapped(_ sender: Any) {
        if let text = textField.text {
            let input = HeadlinesInput.init(text: text)
            if let output = try? Headlines().prediction(input: input) {
                if let feature = output.featureValue(for: "label") {
                    if feature.stringValue == "business" {
                        answerLabel.text = "Business"
                    } else {
                        answerLabel.text = "Sports"
                    }
                }
            }
            
        }
    }

}

