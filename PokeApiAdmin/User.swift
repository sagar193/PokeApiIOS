//
//  User.swift
//  PokeApiAdmin
//
//  Created by User on 04/10/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import Foundation

class User {
    var email:String
    var id:String
    var Pokemons: [String]
    
    init(email: String, id: String, Pokemons: [String]){
        self.email = email
        self.id = id
        self.Pokemons = Pokemons
        
    }
    
}