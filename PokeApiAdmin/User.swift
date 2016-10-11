//
//  User.swift
//  PokeApiAdmin
//
//  Created by User on 04/10/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import Foundation

class User{
    var email:String
    var id:String?
    var role:String
    var password:String?
    
    init(email: String, id: String, role: String){
        self.email = email
        self.id = id
        self.role = role
    }
    
    init(email: String, password: String, role: String){
        self.email = email
        self.password = password
        self.role = role
    }
    
}