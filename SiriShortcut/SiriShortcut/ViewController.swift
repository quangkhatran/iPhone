//
//  ViewController.swift
//  SiriShortcut
//
//  Created by Quang Kha Tran on 01/08/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import Intents
import CoreSpotlight
import CoreServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .red
        let activity = NSUserActivity(activityType: "com.quangkhatran.SiriShortcut.showRed")
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.title = "Show Red"
        activity.userInfo = ["myNumber":45]
        activity.suggestedInvocationPhrase = "Show me the red!"
        let attr = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        let image = UIImage(named: "smartphone")!
        attr.thumbnailData = image.pngData()
        attr.contentDescription = "Show the red app"
        activity.contentAttributeSet = attr
        self.userActivity = activity
        
    }

}

