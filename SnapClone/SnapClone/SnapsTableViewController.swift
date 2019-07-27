//
//  SnapsTableViewController.swift
//  SnapClone
//
//  Created by Quang Kha Tran on 25/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsTableViewController: UITableViewController {
    var snaps : [FIRDataSnapshot] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUserUid = FIRAuth.auth()?.currentUser?.uid {
            FIRDatabase.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childAdded) { (snapshot) in
                self.snaps.append(snapshot)
                self.tableView.reloadData()
            }
            
            FIRDatabase.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childRemoved) { (snapshot) in
                var index = 0
                for snap in self.snaps {
                    if snapshot.key == snap.key {
                        self.snaps.remove(at: index)
                    }
                    index += 1
                }
                self.tableView.reloadData()
            }
            
        }
       
    }

    @IBAction func logOutTapped(_ sender: Any) {
        try? FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if snaps.count == 0 {
            return 1
        } else {
            return snaps.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0 {
            cell.textLabel?.text = "You have no snaps 😭"
        } else {
            let snap = snaps[indexPath.row]
            if let snapDictionary = snap.value as? NSDictionary {
                if let fromEmail = snapDictionary["from"] as? String {
                    cell.textLabel?.text = fromEmail
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if snaps.count > 0 {
            let snap = snaps[indexPath.row]
            performSegue(withIdentifier: "viewSnapSegue", sender: snap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnapSegue" {
            if let viewVC = segue.destination as? ViewSnapViewController {
                if let snap = sender as? FIRDataSnapshot {
                    viewVC.snap = snap 
                }
            }
        }
    }
    

}
