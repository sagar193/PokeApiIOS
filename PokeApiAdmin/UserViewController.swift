//
//  UserViewController.swift
//  PokeApiAdmin
//
//  Created by User on 10/10/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    //MARK: UIElements
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var rolePickerView: UIPickerView!
    
    //MARK: Variables
    var alertMessage: AlertMessage!
    var api: PokeApi!
    var rolePickerViewData: [String]!
    //This value is either passed by 'UserTableViewController' in 'prepareForSegue(_:sender:)' or constructed as part of adding a new user.
    var user: User!
    //TODO: Implement existingUser bool everywhere
    var existingUser: Bool!
    
    
    
    //MARK: Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        let isPresentingInAddUserMode = presentingViewController is UINavigationController
        if isPresentingInAddUserMode{
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        let email = emailTextField.text
        let password = passwordTextField.text
        let role = roleTextField.text
        let id = idTextField.text
        let user = User(email: email!, id: id!, password: password!, role: role!)
        
        if existingUser! {            
            api.editUser(user, completionHandler: {error, rUser in
                if (error != nil) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.alertMessage.displayErrorMessage(error!, ViewController: self)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.user = User(email: (rUser?.email)!, id: (rUser?.id)!, role: (rUser?.role)!)
                        self.performSegueWithIdentifier("unwindToUserTable", sender: self)
                    })
                }
            })
        } else {
            api.saveUser(user, completionHandler: {error, rUser in
                if (error != nil){
                    dispatch_async(dispatch_get_main_queue(), {
                        self.alertMessage.displayErrorMessage(error!, ViewController: self)
                    })
                } else {
                    self.user = User(email: (rUser?.email)!, id: (rUser?.id)!, role: (rUser?.role)!)
                    self.performSegueWithIdentifier("unwindToUserTable", sender: self)
                }
            })
            
        }
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
        if existingUser! {
            if email.isEmpty || role.isEmpty {
                saveButton.enabled = false
            } else {
                saveButton.enabled = true
            }
        } else {
            if email.isEmpty || password.isEmpty || role.isEmpty {
                saveButton.enabled = false
            } else {
                saveButton.enabled = true
            }
        }
    }
    
    @IBAction func textFieldValueChanged(sender: AnyObject) {
        checkValidTextFields()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        rolePickerView.hidden = false
        roleTextField.hidden = true
        return false
    }
    
    //MARK: UIPickerViewDelegates
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rolePickerViewData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rolePickerViewData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        roleTextField.text = rolePickerViewData[row]
        rolePickerView.hidden = true
        roleTextField.hidden = false
        checkValidTextFields()
    }
    
    //MARK: Actions    
    override func viewDidLoad() {
        self.api = PokeApi.instance
        self.alertMessage = AlertMessage.instance
        super.viewDidLoad()
        
        //Fill rolePickerView
        api.getAvailableRoles({ responseError, users in
            if responseError != nil {
                self.alertMessage.displayErrorMessage(responseError!, ViewController: self)
            } else {
                self.rolePickerViewData = users
                if !self.existingUser! {
                    self.roleTextField.text = self.rolePickerViewData[0]
                }
            }
        })
        
        //Execute dismissKeyboard when there is a tap gesture not on any element
        tap.addTarget(self, action: #selector(UserViewController.dismissKeyboard))
        
        //Setup the view to edit an existing
        if let user = user {
            existingUser = true
            navigationItem.title = user.email
            idTextField.text = user.id
            emailTextField.text = user.email
            roleTextField.text = user.role
        } else {
            existingUser = false
        }
        
        //Enable the save button only if the text field has a valid user name.
        checkValidTextFields()
    }
    
    //Function to dismiss the keyboard
    func dismissKeyboard(){
        view.endEditing(true)
        rolePickerView.hidden = true
        roleTextField.hidden = false
    }
    
}