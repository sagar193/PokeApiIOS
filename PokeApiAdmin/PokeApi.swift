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
    
    func getTenUsers(page: Int, completionHandler : ( String?, [String]?) -> Void) {
        print("https://pokeapi9001.herokuapp.com/api/users?page=\(page)")
        let url = NSURL(string: "https://pokeapi9001.herokuapp.com/api/users?page=\(page)")
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "GET"
        
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        print("before task")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error: \(error)")
            }
            print("in the get method")
            
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
                    var userArray = [String]()
                    print("user count in API method\(json["data"]!.count)")
                    for i in 0 ..< json["data"]!.count  {
                        if json["data"]![i]["local"]! != nil {
                            userArray.append(json["data"]![i]["local"]!!["email"] as! String)
                        } else if json["data"]![i]["facebook"]! != nil {
                            userArray.append(json["data"]![i]["facebook"]!!["email"] as! String)
                        }
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
    
}