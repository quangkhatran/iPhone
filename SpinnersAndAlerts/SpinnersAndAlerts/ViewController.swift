//
//  ViewController.swift
//  SpinnersAndAlerts
//
//  Created by Quang Kha Tran on 20/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBAction func showAlert(_ sender: Any) {
        let alertController = UIAlertController(title: "Hey there!", message: "Are you sure?", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            print("OK button pressed")
            self.dismiss(animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            print("No button pressed")
            self.dismiss(animated: true
                , completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func pauseApp(_ sender: Any) {
        let activityIndicator = UIActivityIndicatorView(frame:CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        //UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

