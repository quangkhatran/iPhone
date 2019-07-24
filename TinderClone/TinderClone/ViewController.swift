//
//  ViewController.swift
//  TinderClone
//
//  Created by Quang Kha Tran on 22/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import Parse
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let testObject = PFObject(className: "TestTinderClone")
        testObject["foo"] = "bar"
        testObject.saveInBackground { (success, error) in
            if success {
                print("Success")
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }


}

