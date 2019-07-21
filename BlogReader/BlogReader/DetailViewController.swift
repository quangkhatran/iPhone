//
//  DetailViewController.swift
//  BlogReader
//
//  Created by Quang Kha Tran on 19/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    func configureView() {
        // Update the user interface for the detail item.
        
        if let detail = detailItem {
            self.title = detail.value(forKey: "title") as? String
            if let blogWebView = self.webView {
                blogWebView.loadHTMLString((detail.value(forKey: "content") as? String)!
                    , baseURL: nil)
                //blogWebView.text = detail.value(forKey: "content") as? String
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

