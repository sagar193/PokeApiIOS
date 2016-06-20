//
//  RegisterViewController.swift
//  PokeApiAdmin
//
//  Created by User on 16/06/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidAppear(animated: Bool) {
        emailTextField.text = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        
    }
    
    
    @IBAction func Login(sender: AnyObject) {
        let email = emailTextField.text;
        let password = passwordTextField.text;
        
        if (email!.isEmpty || password!.isEmpty) {
            displayAlertmessage("All fields are required")
            return;
        }
        
        NSUserDefaults.standardUserDefaults().setObject(email, forKey: "userEmail")
        NSUserDefaults.standardUserDefaults().synchronize()
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func displayAlertmessage(message: String){
        let alertMessage = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        alertMessage.addAction(okAction)
        self.presentViewController(alertMessage, animated:true, completion:nil)
        
    }

}
