//
//  AlertMessage.swift
//  PokeApiAdmin
//
//  Created by User on 24/06/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import Foundation
import UIKit

class AlertMessage {
    //MARK: Variables
    static let instance = AlertMessage()
    
    //MARK: Inits
    private init() {}
    
    //MARK: Actions
    //This function generates a error message to the given ViewController
    func displayErrorMessage(message: String, ViewController: UIViewController){
        let errorMessage = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        errorMessage.addAction(okAction)
        ViewController.presentViewController(errorMessage, animated:true, completion:nil)
    }
    //This function generates a normal message to the given ViewController
    func displayMessage(message: String, ViewController: UIViewController){
        let errorMessage = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        errorMessage.addAction(okAction)
        ViewController.presentViewController(errorMessage, animated:true, completion:nil)
    }
}