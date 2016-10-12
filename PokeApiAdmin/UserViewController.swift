//
//  UserViewController.swift
//  PokeApiAdmin
//
//  Created by User on 10/10/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import UIKit

class UserViewController: UIViewController{
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
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
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
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let role = roleTextField.text ?? ""
        
        //Set the navigationItem title to the user typed email adress
        if email == "" {
            navigationItem.title = "New User"
        } else {
            navigationItem.title = email
        }
        
        //Disable the save button if text field is empty
        if email.isEmpty || password.isEmpty || role.isEmpty {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
        }
    }
    
    @IBAction func textFieldValueChanged(sender: AnyObject) {
        checkValidTextFields()
    }
    
    //MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Execute dismissKeyboard when there is a tap gesture not on any element
        tap.addTarget(self, action: #selector(UserViewController.dismissKeyboard))
        
        //Enable the save button only if the text field has a valid user name.
        checkValidTextFields()
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
}