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
    }
    
    //MARK: Actions
    override func viewDidAppear(animated: Bool) {
    }
    
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
                //self.roleTextField.text = self.rolePickerViewData[0]
            }
        })
        
        //Execute dismissKeyboard when there is a tap gesture not on any element
        tap.addTarget(self, action: #selector(UserViewController.dismissKeyboard))
        
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