//
//  UserViewController.swift
//  PokeApiAdmin
//
//  Created by User on 10/10/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import UIKit

class UserViewController: UIViewController , UITextFieldDelegate{
    //MARK: UIElements
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet var tap: UITapGestureRecognizer!
    
    //MARK: Variables
    var user: User?
    
    /*
     This value is either passed by 'UserTableViewController' in 'prepareForSegue(_:sender:)'
     or constructed as part of adding a new user.
     */
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let email = emailTextField.text
            let password = passwordTextField.text
            let role = roleTextField.text
            
            user = User(email: email!, password: password!, role: role!)
        }
    }
    
    //MARK: UITextFieldDelegate
    func checkValidTextFields(){
        //Disable the save button if text field is empty
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let role = roleTextField.text ?? ""
        
        if email.isEmpty || password.isEmpty || role.isEmpty {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        if textField.text == "" {
            navigationItem.title = "New User"
        } else {
            navigationItem.title = textField.text
        }
    }
    @IBAction func emailTextFieldValueChanged(sender: AnyObject) {
        checkValidTextFields()
    }
    
    @IBAction func passwordTextFieldValueChanged(sender: AnyObject) {
        checkValidTextFields()
    }
    
    @IBAction func roleTextFieldValueChanged(sender: AnyObject) {
        checkValidTextFields()
    }
    
    
    //MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Execute dismissKeyboard when there is a tap gesture not on any element
        tap.addTarget(self, action: #selector(UserViewController.dismissKeyboard))
        
        //Handle the text field's user input through delegate callbacks.
        emailTextField.delegate = self
        
        //Enable the save button only if the text field has a valid user name.
        checkValidTextFields()
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
}