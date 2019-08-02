//
//  ViewController.swift
//  ImageClassifier
//
//  Created by Quang Kha Tran on 02/08/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var dogLabel: UILabel!
    
    @IBOutlet weak var catLabel: UILabel!
    
    var picker = UIImagePickerController()
    
    
    @IBAction func choosePhotoTapped(_ sender: Any) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            processImage(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func processImage(image: UIImage) {
        if let model = try? VNCoreMLModel(for: ImageClassifier().model) {
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if let results = request.results as? [VNClassificationObservation] {
                    for result in results {
                        print("\(result.identifier): \(result.confidence * 100)%")
                        if result.identifier == "cats" {
                            let resultRounded = Int((result.confidence * 100.0).rounded())
                            self.catLabel.text = "\(resultRounded)%"
                        }
                        if result.identifier == "dogs" {
                            let resultRounded = Int((result.confidence * 100.0).rounded())
                            self.dogLabel.text = "\(resultRounded)%"
                        }
                    }
                }
            }
            
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let handler = VNImageRequestHandler(data: imageData, options: [:])
                try? handler.perform([request])
            }
            
        }
        
    }
    
    
    @IBAction func cameraTapped(_ sender: Any) {
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        
        
    }


}

