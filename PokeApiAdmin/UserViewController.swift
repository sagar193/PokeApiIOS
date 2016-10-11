//
//  UserViewController.swift
//  PokeApiAdmin
//
//  Created by User on 10/10/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet weak var saveButton: UserViewController!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    
    /*
     This value is either passed by 'UserTableViewController' in 'prepareForSegue(_:sender:)'
     or constructed as part of adding a new user.
     */
    var user: User?
    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            let email = emailTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            let role = roleTextField.text ?? ""
            
            user = User(email: email, password: password, role: role)
        }
    }
    
    //MARK: Actions
    
}