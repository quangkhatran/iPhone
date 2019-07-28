//
//  ViewController.swift
//  BluetoothDevice
//
//  Created by Quang Kha Tran on 28/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var centralManager: CBCentralManager?
    var names: [String] = []
    var RSSIs: [NSNumber] = []
    var timer: Timer?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "blueCell", for: indexPath) as? BlueTableViewCell {
            cell.nameLabel.text = names[indexPath.row]
            cell.rssiLabel.text = "RSSI: \(RSSIs[indexPath.row])"
            return cell
        }
        
        return UITableViewCell()
    }
    
    func startTimer(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true
            , block: { (timer) in
                self.startScan()
        })
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        startScan()
        startTimer()
    }
    
    func startScan(){
        names = []
        RSSIs = []
        tableView.reloadData()
        centralManager?.stopScan()
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // CBCentralManager code
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn { // bluetooth working
            startScan()
            startTimer()
        } else { // bluetooth not working
            let alertVC = UIAlertController(title: "Bluetooth isn't working", message: "Make sure your bluetooth is on and ready to rock and roll", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                alertVC.dismiss(animated: true, completion: nil)
                
            }
            alertVC.addAction(okAction)
            present(alertVC, animated: true, completion: nil)
        }
    }

    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name {
            print("Peripheral name: \(name)")
        } else {
            names.append(peripheral.identifier.uuidString)
        }
        RSSIs.append(RSSI)
        tableView.reloadData()
    }
    
    

}

