//
//  ViewController.swift
//  TouchIDDemo
//
//  Created by roger on 2017/4/17.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        detailLbl.text = "Waiting..."
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func touchIDWithiOS8(){
        if #available(iOS 8.0, OSX 10.12, *) {
            let policy: LAPolicy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
            touchIDAuthentication(policy: policy)
        } else {
            noSupportiOSVersion()
        }
    }
    
    func touchIDWithiOS9(){
        if #available(iOS 9.0, *){
            let policy: LAPolicy = LAPolicy.deviceOwnerAuthentication
            touchIDAuthentication(policy: policy)
        } else {
            noSupportiOSVersion()
        }
    }
    
    func noSupportiOSVersion(){
        // Fallback on earlier versions
        print("update iOS version (8.0 required)")
        DispatchQueue.main.async {
            self.detailLbl.text = "No Support"
            self.textView.text = "update iOS version (8.0 required)"
        }
    }
    
    func touchIDAuthentication(policy: LAPolicy){
        /*
         touch ID is supported for iphone 5s up iOS 8 up
         */
        print("touchIDAuthentication")
        let myContext = LAContext()
        let myLocalizedReasonString = "Demo Touch ID"
        
        var authError: NSError? = nil
        
            if myContext.canEvaluatePolicy(policy, error: &authError) {
                
                myContext.evaluatePolicy(policy, localizedReason: myLocalizedReasonString) { (success, evaluateError) in
                    if (success) {
                        // User authenticated successfully, take appropriate action
                        print("Success")
                        DispatchQueue.main.async {
                            self.detailLbl.text = "Success"
                            self.textView.text = ""
                        }
                        
                    } else {
                        // User did not authenticate successfully, look at error and take appropriate action
                        print("Failed")
                        DispatchQueue.main.async {
                            self.detailLbl.text = "Failed"
                            
                            self.textView.text = "\((evaluateError as! NSError).code)\n\((evaluateError as! NSError).localizedDescription)"
                        }
                        
                        print("\(evaluateError)")
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                DispatchQueue.main.async {
                    self.textView.text = "\(authError?.description) \n code=\(authError?.code)"
                }
                print("\(authError)")
            }
    }
    
    
    @IBAction func iOS8BtnPressed(_ sender: Any) {
        touchIDWithiOS8()
    }
    
    @IBAction func iOS9BtnPressed(_ sender: Any) {
        touchIDWithiOS9()
    }
    
    
}

