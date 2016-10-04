//
//  ViewController.swift
//  PokeApiAdmin
//
//  Created by User on 09/06/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var users: [String] = []
    var page = 1
    var loadingMore = false
    var moreData = true
    let api = PokeApi()
    let alertMassage = AlertMessage()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        users = []
        page = 0
        moreData = true
        
        
        //var errorCode: Int?, errorMessage: String?, users: [String]
        
        loadMore()
    }
    
    let threshold = 100.0 // threshold from bottom of tableView
    var isLoadingMore = false // flag

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customcell", forIndexPath: indexPath) as UITableViewCell!
        cell.textLabel?.text = users[indexPath.item]
        return cell
        
    }
    
    func loadMore(){
        page += 1
        print("loading more \(page)")
        api.getTenUsers(page, completionHandler: { errorMessage, newUsers in
            if errorMessage != nil {
                self.alertMassage.displayErrorMessage(errorMessage!, ViewController: self)
            }
            if newUsers?.count == 0 {
                self.moreData = false
                return
            }
            self.users += newUsers!
            self.loadingMore = false
        })
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == users.count - 1 && moreData == true{
            if loadingMore == false {
                loadingMore = true
                loadMore()
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped cell number \(indexPath.row)")
    }

}

