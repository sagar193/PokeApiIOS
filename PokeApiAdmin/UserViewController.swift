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
    //TODO: Split UITextFieldDelegate into another file and make it so every textfield enable/disable buttons/navigation items
    func textFieldDidBeginEditing(textField: UITextField){
        //Disable the save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidUserName(){
        //Disable the save button if text field is empty
        let text = emailTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        checkValidUserName()
        if textField.text == "" {
            navigationItem.title = "New User"
        } else {
            navigationItem.title = textField.text
        }
    }
    
    
    //MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Execute dismissKeyboard when there is a tap gesture not on any element
        tap.addTarget(self, action: #selector(UserViewController.dismissKeyboard))
        
        //Handle the text field's user input through delegate callbacks.
        emailTextField.delegate = self
        
        //Enable the save button only if the text field has a valid user name.
        checkValidUserName()
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
}