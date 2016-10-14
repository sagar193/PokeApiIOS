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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: Variables
    var alertMessage: AlertMessage!
    var api: PokeApi!
    
    
    //This value is either passed by 'UserTableViewController' in 'prepareForSegue(_:sender:)' or constructed as part of adding a new user.
    var user: User!
    
    //MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        let email = emailTextField.text
        let password = passwordTextField.text
        let role = roleTextField.text
        let user = User(email: email!, password: password!, role: role!)
        
        api.saveUser(user, completionHandler: {error, rUser in
            print("here \(rUser?.email)")
            if (error != nil){
                dispatch_async(dispatch_get_main_queue(), {
                    self.alertMessage.displayErrorMessage(error!, ViewController: self)
                })
            } else {
                //TODO: insert segue to return back to table view
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let email = emailTextField.text
            let password = passwordTextField.text
            let role = roleTextField.text
            
            self.user = User(email: email!, password: password!, role: role!)
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
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
        api = PokeApi.instance
        alertMessage = AlertMessage.instance
        
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