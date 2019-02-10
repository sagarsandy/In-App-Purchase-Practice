//
//  StoreViewController.swift
//  InAppPurchase
//
//  Created by Sagar Sandy on 17/08/2018.
//  Copyright © 2018 Sagar Sandy. All rights reserved.
//

import UIKit
import StoreKit

class StoreViewController: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productDescripton: UITextView!
    @IBOutlet weak var buyButton: UIButton!
    
    var product: SKProduct?
    var productID = "com.sagarsandy492.iapios12.newlevel"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        buyButton.isEnabled = false
        buyButton.alpha = 0.25
        
        // This will initialize the payment process, and the next method will check whether user is able to purchase the content or not
        SKPaymentQueue.default().add(self)
        getPurchaseInfo()
    }
    
    @IBAction func buyProduct(_ sender: Any) {
        
        let payment = SKPayment(product: product!)
        SKPaymentQueue.default().add(payment)
        
    }
    
    @IBAction func restoreProduct(_ sender: Any) {
        
        // Restoring the purchases, if u re-install the app, then this will be useful
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func getPurchaseInfo() {
        
        if SKPaymentQueue.canMakePayments() {
            
            let request = SKProductsRequest(productIdentifiers: NSSet(objects: self.productID) as! Set<String>)
            
            request.delegate = self
            request.start()
            
        } else {
            
            productTitle.text = "Warning"
            productDescripton.text = "Please enable IAP on your device"
            
        }
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        var products = response.products
        
        if (products.count == 0) {
            
            productTitle.text = "Warning"
            productDescripton.text = "Unable to connect to IAP"
            
        } else {
            
            product = products[0]
            
            productTitle.text = product?.localizedTitle
            productDescripton.text = product?.localizedDescription
            
            buyButton.isEnabled = true
            buyButton.alpha = 1.0
        }
        
        let invalid = response.invalidProductIdentifiers
        
        for product in invalid {
            
            print("\(product)")
            
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.purchased:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                productDescripton.text = "The level was unlocked"
                buyButton.isEnabled = false
                buyButton.alpha = 0.25
                
                let appDel = UIApplication.shared.delegate as! AppDelegate
                appDel.homeController?.enableLevel2()
                
            case SKPaymentTransactionState.failed:
                
                SKPaymentQueue.default().finishTransaction(transaction)
                productDescripton.text = "The item was not purchased"
                
            default:
                break
                
            }
            
        }
        
    }

}
