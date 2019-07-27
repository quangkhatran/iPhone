//
//  ViewSnapViewController.swift
//  SnapClone
//
//  Created by Quang Kha Tran on 26/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class ViewSnapViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var snap : FIRDataSnapshot?
    var imageName = ""
    
    // if we use SDWebImage then use the following code
    override func viewDidLoad() {
        super.viewDidLoad()
        if let snapDictionary = snap?.value as? NSDictionary {
            if let description = snapDictionary["description"] as? String {
                if let imageURL = snapDictionary["imageURL"] as? String{
                    messageLabel.text = description
                    if let url = URL(string: imageURL){
                        imageView.sd_setImage(with: url)
                    }
                    if let imageName = snapDictionary["imageName"] as? String {
                        self.imageName = imageName
                    }
                }
            }
        }
    }
    
    /* // if we don't use SDWebImage then use the following code
    override func viewDidLoad() {
        super.viewDidLoad()
        if let snapDictionary = snap?.value as? NSDictionary {
            if let description = snapDictionary["description"] as? String {
                if let imageURLString = snapDictionary["imageURL"] as? String {
                    if let imageURL = URL(string: imageURLString) {
                        let imageData = try? Data(contentsOf: imageURL)
                        if let image = UIImage(data: imageData!){
                            imageView.image = image
                        }
                        
                    }
                    messageLabel.text = description

                }
            }
        }
    }
 */
    
    override func viewWillDisappear(_ animated: Bool) {
        if let currentUserUid = FIRAuth.auth()?.currentUser?.uid {
            if let key = snap?.key {
                FIRDatabase.database().reference().child("users").child(currentUserUid).child("snaps").child(key).removeValue()
                FIRStorage.storage().reference().child("images").child(imageName).delete(completion: nil)
            }
        }
    }
    
}
