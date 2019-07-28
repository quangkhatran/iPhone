//
//  ViewController.swift
//  PushNotifications
//
//  Created by Quang Kha Tran on 28/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let url = URL(string: "https://fcm.googleapis.com/fcm/send") {
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = ["Content-Type":"application/json","Authorization":"key=AAAAW82XYeI:APA91bH6bnnbz8gUlUhQAQ3zp3ULZFU_715A6XpXfZuv6ZiMq7NugC0rZv7NVw-H8dmGbIkOjELi2isQZvLUayV7I9D7B3o-Sc9p1kWmUKE08gU0mcJRkS2rVCYKWN4G_2U1UqjdHYDp"]
            request.httpMethod = "POST"
            request.httpBody = "{  \"to\":\"ePtiTghc-1k:APA91bEiJFoHafHT_nNDcIXasBnX83kEbwuFp372v8vMNat8XM6nC-8_4tPgnCDgWlEjR-kL054BM2Cx-95UqFc-V8H-luE54k05kmCM50wQJA19Q8vVe4b0cf3eauA0R9vrF5CYReZM\",\"notification\":{\"title\":\"THIS IS A TESTING MESSAGE 2!\"}}".data(using: .utf8)
            URLSession.shared.dataTask(with: request) { (data, urlresponse, error) in
                if error != nil {
                    print(error!)
                }
            }.resume()

        }
        
    }


}

