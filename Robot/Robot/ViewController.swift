//
//  ViewController.swift
//  Robot
//
//  Created by Quang Kha Tran on 31/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        INPreferences.requestSiriAuthorization { (status) in
            if status == .authorized {
                print("We can use Siri!")
            }
        }
    }


}

