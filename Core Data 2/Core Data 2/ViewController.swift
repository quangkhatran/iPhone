//
//  ViewController.swift
//  Core Data 2
//
//  Created by Quang Kha Tran on 19/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        /*
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
        newUser.setValue("ralphie", forKey: "username")
        newUser.setValue("tommysPass", forKey: "password")
        newUser.setValue(2, forKey: "age")
 
       
        do {
            try context.save()
            print("Saved")
        } catch {
            print("There was an error")
        }
        */
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        //request.predicate = NSPredicate(format: "username = %@", "Dooley")
        
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let username = result.value(forKey: "username") as? String {
                        /*
                        result.setValue("Dooley", forKey: "username")
                        do {
                            try context.save()
                        } catch {
                            print("Rename failed")
                        }
 */
                        /*
                        context.delete(result)
                        do {
                            try context.save()
                        } catch {
                            print("Delete failed")
                        }
                        */
                        print(username)
                    }
                    
                }
            }
        } catch {
            print("Couldn't fetch results")
        }
        
        
        
    }


}

