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
    func displayErrorMessage(message: String, ViewController: UIViewController){
        let errorMessage = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        errorMessage.addAction(okAction)
        ViewController.presentViewController(errorMessage, animated:true, completion:nil)
    }
    func displayMessage(message: String, ViewController: UIViewController){
        let errorMessage = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        
        errorMessage.addAction(okAction)
        ViewController.presentViewController(errorMessage, animated:true, completion:nil)
    }
}