//
//  ViewController.swift
//  InAppPurchase
//
//  Created by Quang Kha Tran on 30/07/2019.
//  Copyright © 2019 Quang Kha Tran. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    var activeProduct: SKProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SKPaymentQueue.default().add(self)
        
        let productIds: Set<String> = ["com.quangkhatran.InAppPurchase.gold"]
        let prodReq = SKProductsRequest(productIdentifiers: productIds)
        prodReq.delegate = self
        prodReq.start()
        
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded Products")
        for product in response.products {
            print("Product: \(product.productIdentifier) \(product.localizedTitle) \(product.price.floatValue)")
            nameLabel.text = product.localizedTitle
            activeProduct = product
        }
    }
    
    @IBAction func buyTapped(_ sender: Any) {
        
        if let activeProduct = activeProduct {
            print("Buying...")
            let payment = SKPayment(product: activeProduct)
            SKPaymentQueue.default().add(payment)
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch(transaction.transactionState){
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                resultLabel.text = "YOU GOT SOME GOLD"
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                resultLabel.text = "SOMETHING WENT WRONG"
            default:
                break
            }
        }
        
    }
    
    
}

