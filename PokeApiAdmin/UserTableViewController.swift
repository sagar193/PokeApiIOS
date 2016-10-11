//
//  ViewController.swift
//  PokeApiAdmin
//
//  Created by User on 09/06/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import UIKit

class UserTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var users: [User] = []
    var page = 0
    var loadingMore = false
    var moreData = true
    let api = PokeApi.instance
    let alertMassage = AlertMessage()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        users = []
        page = 0
        moreData = true
        
        loadMore()
    }
    
    let threshold = 100.0 // threshold from bottom of tableView
    var isLoadingMore = false // flag

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customcell", forIndexPath: indexPath) as UITableViewCell!
        cell.textLabel?.text = users[indexPath.item].email
        return cell
        
    }
    
    func loadMore(){
        page += 1
        api.getTenUsers(page, completionHandler: { errorMessage, newUsers in
            if errorMessage != nil {
                self.alertMassage.displayErrorMessage(errorMessage!, ViewController: self)
            }
            if newUsers?.count == 0 {
                self.moreData = false
                return
            }
            self.users += newUsers!
            //reload tableView data not asynch
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
            self.loadingMore = false
        })
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == users.count - 1 && moreData == true{
            if loadingMore == false {
                loadingMore = true
                loadMore()
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You tapped cell number \(indexPath.row)")
    }

}

