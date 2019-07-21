//
//  ViewController.swift
//  DownloadImagesFromWeb
//
//  Created by Quang Kha Tran on 19/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if path.count > 0 {
            let directory = path[0]
            let restorePath = directory + "/snake.jpg"
            
            imageView.image = UIImage(contentsOfFile: restorePath)
            
        }
        
        /*
        let url = URL(string: "https://img.ev.mu/images/articles/960x/924930.jpg")!
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                print(error)
            } else {
                if let data = data {
                    if let image = UIImage(data: data){
                        self.imageView.image = image
                        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                        if path.count > 0 {
                            let directory = path[0] as! String
                            let savePath = directory + "/snake.jpg"
                            do {
                                let imagePresentation = image.jpegData(compressionQuality: 1)
                                try imagePresentation?.write(to: URL(fileURLWithPath: savePath))
                                print("Saved")
                            } catch {
                                print("Fail to save image")
                                    // process error
                            }
                        }
                    }
                }
            }
        }
        task.resume()
 */
    }


}

