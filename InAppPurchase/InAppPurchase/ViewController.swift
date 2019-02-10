//
//  ViewController.swift
//  InAppPurchase
//
//  Created by Sagar Sandy on 17/08/2018.
//  Copyright © 2018 Sagar Sandy All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var level2Button: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Cehcking the purchase status stored in the user defaults
        let save = UserDefaults.standard
        if save.value(forKey: "Purchased") == nil {
            
            level2Button.isEnabled = false
            level2Button.alpha = 0.25
            
        } else {
            
            level2Button.isEnabled = true
            level2Button.alpha = 1.0
            
        }
        
    }
    
    func enableLevel2() {
        
        level2Button.isEnabled = true
        level2Button.alpha = 1.0
        
        let save = UserDefaults.standard
        save.setValue(true, forKey: "Purchased")
        save.synchronize()
        
    }


}

