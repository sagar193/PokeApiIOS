//
//  RegisterViewController.swift
//  PokeApiAdmin
//
//  Created by User on 16/06/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var alertMessage: AlertMessage!
    
    override func viewDidAppear(animated: Bool) {
        emailTextField.text = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        alertMessage = AlertMessage()
    }
    
    
    @IBAction func Login(sender: AnyObject) {
        let email = emailTextField.text;
        let password = passwordTextField.text;
        
        if (email!.isEmpty || password!.isEmpty) {
            alertMessage.displayErrorMessage("All fields are required", ViewController: self)
            return;
        }
        
        let pokeApi = PokeApi()
        pokeApi.login(email!, password: password!, completionHandler: { responseCode, error in
            if responseCode == 200 {
                NSUserDefaults.standardUserDefaults().setObject(email, forKey: "userEmail")
                NSUserDefaults.standardUserDefaults().synchronize()
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("mainViewController", sender: self)
                    });
            } else if responseCode == 401 {
                self.alertMessage.displayErrorMessage("Invalid credentials provided", ViewController: self)
                return;
            } else {
                self.alertMessage.displayErrorMessage("response code :\(responseCode)", ViewController: self)
            }
        })
        
        //getCurrentUser_request()
        
        
        
    }    
    
    

}
