//
//  Tools.swift
//  StripeDemo
//
//  Created by Roger Rush on 2/7/17.
//  Copyright © 2017 Roger Rush. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import Alamofire

let stripePublishableKey = "pk_test_PYgdxXGX8pHfw8ejL2Lmsruj"

let AzureURL = "http://rainy-day-fuel.azurewebsites.net"

func chargeFromToken(token: STPToken, amount: Int) {
    let url = AzureURL + "/charge.php"
    let params = [
        "stripeToken": token.tokenId,
        "amount": amount,
        "currency": "usd",
        "description": "Get gas"
    ] as [String : Any]
    Alamofire.request(url, parameters: params as? [String : AnyObject])
}

func chargeFromCustomerId(cid: String, amount: Double, description: String, capture: Bool) {
    let urlExtension = capture ? "/charge.php" : "/authorize.php"
    let url = AzureURL + urlExtension
    let params = [
        "cid": cid,
        "amount": amount,
        "description": description
    ] as [String : Any]
    Alamofire.request(url, parameters: params as? [String : AnyObject])
}

func customerIdFromToken(token: STPToken, name: String, email: String, completion: @escaping (Bool) -> ()) {
    let url = AzureURL + "/newcustomer.php"
    let params = [
        "token": token,
        "name": name,
        "email": email
    ] as [String : Any]
    Alamofire.request(url, parameters: params)
        .responseJSON { response in
            print("Request: ", response.request)
            print("Response: ", response.response)
            print("Data: ", response.data)
            print("Result: ", response.result)
            print("Result.value: ", response.result.value)
    }
}

func createNewStripeCustomerFromCardInfo(nameTextField: UITextField, emailTextField: UITextField, numberTextField: UITextField, expirationTextField: UITextField, cvvTextField: UITextField) -> String {
    
    // Parse date
    var expMonth: UInt!
    var expYear: UInt!
    if expirationTextField.text!.isEmpty == false {
        let expirationDate = expirationTextField.text!.components(separatedBy: "/")
        expMonth = UInt(expirationDate[0])
        expYear = UInt(expirationDate[1])
    }
    
    // Initiate Stripe card
    let stripCard = STPCardParams()
    
    stripCard.number = numberTextField.text
    stripCard.cvc = cvvTextField.text
    stripCard.expMonth = expMonth!
    stripCard.expYear = expYear!
    
    // Validate card
    if STPCardValidator.validationState(forCard: stripCard) == .valid {
        print ("The card is valid")
    } else {
        print ("Invalid card")
        let alert = UIAlertController(title: "Invalid Card", message: "Card entered is not valid. Please double check or try another card.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        alert.present(alert, animated: true, completion: nil)
        return "Invalid"
    }
    
    // Get token from card
    let apiClient = STPAPIClient(publishableKey: stripePublishableKey)
    apiClient.createToken(withCard: stripCard, completion: { (token, error) -> Void in
        
        if error != nil {
            print ("error sending token!")
            return
        }
        print ("Token:", token)
        
        // Create customer with token (save returned customer id from Stripe)
        customerIdFromToken(token: token!, name: nameTextField.text!, email: emailTextField.text!) { success in
            return "Success"
        }
    })
    return "Failure"
}

