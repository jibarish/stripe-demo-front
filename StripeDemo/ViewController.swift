//
//  ViewController.swift
//  StripeDemo
//
//  Created by Roger Rush on 2/7/17.
//  Copyright © 2017 Roger Rush. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var expTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func handleCreateCustomerBtn(_ sender: Any) {
        
        // Null check all fields
        if (nameTextField.text == "" ||
            numberTextField.text == "" ||
            expTextField.text == "" ||
            cvcTextField.text == "") {
            let alert = UIAlertController(title: "Missing fields", message: "Please fill in all fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Validate number
        if (numberTextField.text?.characters.count != 16) {
            let alert = UIAlertController(title: "Invalid card number", message: "Please enter a valid credit card number with no spaces.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Validate expiration
        if let expirationDate = expTextField.text?.components(separatedBy: "/") {
            if (expirationDate.count < 2 ||
                Int(expirationDate[0]) == nil ||
                Int(expirationDate[1]) == nil ||
                Int(expirationDate[1])! < 16 ||
                Int(expirationDate[0])! > 12 ||
                Int(expirationDate[0])! < 1) {
                
                let alert = UIAlertController(title: "Invalid expiration", message: "Please enter a valid expiration date.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
        }
        
        // Validate cvc
        if (cvcTextField.text?.characters.count != 3 ||
            Int(cvcTextField.text ?? "") == nil) {
            let alert = UIAlertController(title: "Invalid cvc", message: "Please enter a valid 3-digit cvc code.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        createNewStripeCustomerFromCardInfo(nameTextField: nameTextField, emailTextField: emailTextField, numberTextField: numberTextField, expirationTextField: expTextField, cvvTextField: cvcTextField)
    }
}

