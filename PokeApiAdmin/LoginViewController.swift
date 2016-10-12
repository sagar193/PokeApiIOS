//
//  RegisterViewController.swift
//  PokeApiAdmin
//
//  Created by User on 16/06/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    //MARK: Variables
    let pokeApi = PokeApi.instance
    var alertMessage: AlertMessage!
    
    //MARK: UIElements
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    //MARK: Actions
    override func viewDidAppear(animated: Bool) {
        alertMessage = AlertMessage()
        
        //fill the email textfield
        emailTextField.text = NSUserDefaults.standardUserDefaults().stringForKey("userEmail")
        //make it possible to dismiss the keyboard via a tap gesture
        tapGestureRecognizer.addTarget(self, action: #selector(LoginViewController.dismissKeyboard))
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        enableOrDisableLoginButton()
    }
    
    func enableOrDisableLoginButton(){
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if email.isEmpty || password.isEmpty {
            loginButton.enabled = false
        } else {
            loginButton.enabled = true
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        enableOrDisableLoginButton()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        enableOrDisableLoginButton()
    }
    
    @IBAction func emailTextFieldValueChanged(sender: AnyObject) {
        enableOrDisableLoginButton()
    }
    
    @IBAction func passwordTextFieldValueChanged(sender: AnyObject) {
        enableOrDisableLoginButton()
    }

    
    @IBAction func Login(sender: AnyObject) {
        let email = emailTextField.text;
        let password = passwordTextField.text;
        
        if (email!.isEmpty || password!.isEmpty) {
            alertMessage.displayErrorMessage("All fields are required", ViewController: self)
            return
        }
        
        pokeApi.login(email!, password: password!, completionHandler: { responseCode, error in
            if responseCode == 200 {
                NSUserDefaults.standardUserDefaults().setObject(email, forKey: "userEmail")
                NSUserDefaults.standardUserDefaults().synchronize()
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("userTableViewController", sender: self)
                    })
            } else if responseCode == 401 {
                dispatch_async(dispatch_get_main_queue(), {
                    self.alertMessage.displayErrorMessage("Invalid credentials provided", ViewController: self)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.alertMessage.displayErrorMessage("response code :\(responseCode)", ViewController: self)
                })
            }
        })       
        
        
    }    
    
    func dismissKeyboard(){
        view.endEditing(true)
    }

}
