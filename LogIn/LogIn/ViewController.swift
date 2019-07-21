//
//  ViewController.swift
//  LogIn
//
//  Created by Quang Kha Tran on 19/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    var isLoggedIn = false
    
    
    
    @IBAction func logIn(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if isLoggedIn {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            do {
                let results = try context.fetch(request)
                if results.count > 0 {
                    for result in (results as? [NSManagedObject])! {
                        result.setValue(textField.text, forKey: "name")
                        do {
                            try context.save()
                        } catch {
                            print("Update username save failed")
                        }
                    }
                    label.text = "Hi " + textField.text! + "!"
                }
            } catch {
                print("Update username failed")
            }
        } else {
            let newValue = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
            newValue.setValue(textField.text, forKey: "name")
            do {
               
                try context.save()
                
                logInButton.setTitle("Update", for:[])
                
                textField.alpha = 1
                label.alpha = 1
                label.text = "Hi " + textField.text! + "!"
                logOutButton.alpha = 1
                isLoggedIn = true
            } catch {
                print("Failed to save")
            }
        }
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        do{
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results {
                    context.delete(result as! NSManagedObject)
                    do{
                        try context.save()
                    } catch {
                        print("Individual delete failed")
                    }
                }
                label.alpha = 0
                logInButton.setTitle("Log In", for:[])
                logOutButton.alpha = 0
                textField.alpha = 1
                logInButton.alpha = 1
                isLoggedIn = false
            }
        } catch {
            print("Delete failed")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        logOutButton.alpha = 0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject] {
                if let username = result.value(forKey: "name") as? String {
                    logOutButton.alpha = 1
                    textField.alpha = 0
                    logInButton.setTitle("Update username", for: [])
                    label.alpha = 1
                    label.text = "Hi " + username + "!"
                    
                }
            }
        } catch {
            print("Request failed")
        }
    }


}

