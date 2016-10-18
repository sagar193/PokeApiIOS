//
//  ApiController.swift
//  PokeApiAdmin
//
//  Created by User on 21/06/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import Foundation

enum JSONError: String, ErrorType {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

class PokeApi {
    //MARK: Variables
    var roles = [String: String]()
    static let instance = PokeApi()
    
    //MARK:Inits
    private init() { }
    
    //MARK: Actions
    func login(email: String, password: String, completionHandler :(Int?, String?) -> Void){
        let url = NSURL(string: "https://pokeapi9001.herokuapp.com/api/login/")
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "POST"
    
        let postString = "email=\(email)&password=\(password)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
    
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
    
    
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
        
            if error != nil {
                print("error: \(error)")
            }
            
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                completionHandler(json["status"]!.integerValue, nil )
            } catch let error as JSONError {
                completionHandler(nil, error.rawValue)
            } catch let error as NSError {
                completionHandler(nil, error.debugDescription)
            }
        
        }
        task.resume()
    }
    
    func getCurrentUser( completionHandler : (Int?, String?) -> Void){
        let url = NSURL(string: "https://pokeapi9001.herokuapp.com/api/profile/")
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "GET"
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error: \(error)")
            }
            
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                if json["status"]!.integerValue == 401 {
                    completionHandler(json["status"]!.integerValue, "not logged in")
                } else if json["status"]!.integerValue == 200 {
                    completionHandler(json["status"]!.integerValue, json["data"]!["local"]!!["email"]! as? String)
                } else {
                    completionHandler(json["status"]!.integerValue, "unexpected error")
                }
                
            } catch let error as JSONError {
                completionHandler(nil, error.rawValue)
            } catch let error as NSError {
                completionHandler(nil, error.debugDescription)
            }
        }
        task.resume()
    }
    
    func getTenUsers(page: Int, completionHandler : ( String?, [User]?) -> Void) {
        getRoles { ( str1, role) in }
        
        let url = NSURL(string: "https://pokeapi9001.herokuapp.com/api/users?page=\(page)")
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "GET"
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error: \(error)")
            }
            
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                if json["status"]!.integerValue == 401 {
                    completionHandler("not logged in", nil)
                } else if json["status"]!.integerValue == 200 {
                    var userArray = [User]()
                    for i in 0 ..< json["data"]!.count  {
                        //get name
                        var name: String = ""
                        if json["data"]![i]["local"]! != nil {
                            name = json["data"]![i]["local"]!!["email"] as! String
                        } else if json["data"]![i]["facebook"]! != nil {
                            name = json["data"]![i]["facebook"]!!["email"] as! String
                        }
                        //get id
                        let id = json["data"]![i]["_id"]!! as! String
                        //get roles
                        
                        var role = json["data"]![i]["role"]!! as! String
                        role = self.roles[role]!
                        let user = User(email: name, id: id, role: role)
                        userArray.append(user)
                    }
                    
                    completionHandler(nil, userArray)
                } else {
                    completionHandler("unexpected error", nil)
                }
                
            } catch let error as JSONError {
                completionHandler(error.rawValue, nil)
            } catch let error as NSError {
                completionHandler(error.debugDescription, nil)
            }
        }
        task.resume()
    }
    
    func getRoles(completionHandler: (String?, [String: String]?) -> Void) {
        //Set up the url and HTTP Method
        let url = NSURL(string: "https://pokeapi9001.herokuapp.com/api/roles")
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "GET"
        
        request.cachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("Error: \(error)")
                return
            }
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                //If data parsing to JSON  doesn't works then execute the following code
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                // if data parsing works, but an 401 is given
                }
                if json["status"]!.integerValue == 401 {
                    completionHandler("User not logged in!", nil)
                // if a status 200 is given
                } else if json["status"]!.integerValue == 200 {
                    //Create a fresh instance of roles
                    self.roles = [:]
                    //Add every role
                    for i in 0 ..< json["data"]!.count {
                        let id = json["data"]![i]["_id"]!! as! String
                        let name = json["data"]![i]["name"]!! as! String
                        self.roles[id] = name
                    }
                    completionHandler(nil, self.roles)
                //if neither a 401 or a 200 error is given by the server
                } else {
                    completionHandler("unexpected error", nil)
                }
            //Data parsing failed, code is printed to the console
            //More clear error messages might have to be implemented
            } catch let error as JSONError {
                completionHandler(error.rawValue, nil)
            } catch let error as NSError {
                completionHandler(error.debugDescription, nil)
            }
        }
        task.resume()
    }
    
    func getAvailableRoles(completionHandler: (String?, [String]?) -> Void) {
        //Set up the url and HTTP Method
        let url = NSURL(string: "https://pokeapi9001.herokuapp.com/api/roles")
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "GET"
        
        request.cachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("Error: \(error)")
                return
            }
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                //If data parsing to JSON  doesn't works then execute the following code
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                // if data parsing works, but an 401 is given
                if json["status"]!.integerValue == 401 {
                    completionHandler("User not logged in!", nil)
                    // if a status 200 is given
                } else if json["status"]!.integerValue == 200 {
                    //Create a fresh instance of roles
                    var roleNames: [String] = []
                    //Add every role
                    for i in 0 ..< json["data"]!.count {
                        let name = json["data"]![i]["name"]!! as! String
                        roleNames.append(name)
                    }
                    completionHandler(nil, roleNames)
                    //if neither a 401 or a 200 error is given by the server
                } else {
                    completionHandler("unexpected error", nil)
                }
                //Data parsing failed, code is printed to the console
                //More clear error messages might have to be implemented
            } catch let error as JSONError {
                completionHandler(error.rawValue, nil)
            } catch let error as NSError {
                completionHandler(error.debugDescription, nil)
            }
        }
        task.resume()
    }
    
    func saveUser(user: User, completionHandler: (String?, User?) -> Void) {
        let url = NSURL(string: "https://pokeapi9001.herokuapp.com/api/users/")
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "POST"
        
        let postString = "email=\(user.email)&password=\(user.password)&role=\(user.role)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                print("error: \(error)")
            }
            
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                
                
                if json["status"]!.integerValue == 401 {
                    completionHandler("User not logged in!", nil)
                    // if a status 200 is given
                } else if json["status"]!.integerValue == 201 {
                    //get name
                    var name: String = ""
                    if json["data"]!["local"]! != nil {
                        name = json["data"]!["local"]!!["email"] as! String
                    } else if json["data"]!["facebook"]! != nil {
                        name = json["data"]!["facebook"]!!["email"] as! String
                    }
                    //get id
                    let id = json["data"]!["_id"]!! as! String
                    //get roles
                    var role = json["data"]!["role"]!! as! String
                    role = self.roles[role]!
                    
                    let user = User(email: name, id: id, role: role)
                
                    completionHandler(nil, user)
                    
                } else if json["status"]!.integerValue == 400 {
                    completionHandler(json["data"] as? String, nil)
                } else {
                    completionHandler("Unknown error occured", nil)
                }
                
            } catch let error as JSONError {
                completionHandler(error.rawValue, nil)
            } catch let error as NSError {
                completionHandler(error.debugDescription, nil)
            }
            
        }
        task.resume()
    }
    
}