//
//  ViewController.swift
//  PokeApiAdmin
//
//  Created by User on 09/06/16.
//  Copyright © 2016 Sagar. All rights reserved.
//

import UIKit

class UserTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    //MARK: Variables
    var users: [User]!
    var page: Int!
    var loadingMore: Bool!
    var moreData: Bool!
    var api: PokeApi!
    var alertMessage: AlertMessage!
    var addedUsers: [String]!
    
    //MARK: UIElements
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Navigation
    @IBAction func unwindToUserList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.sourceViewController as? UserViewController, user = sourceViewController.user {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                print("user edited \(selectedIndexPath.row)")
                //update an selected user
                users[selectedIndexPath.row] = user
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                print("user added")
                //add a new user
                let newIndexPath = NSIndexPath(forRow: users.count, inSection: 0)
                addedUsers.append(user.id!)
                users.append(user)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Right)
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let userViewController = segue.destinationViewController as! UserViewController
            
            //get the cell that generated this segue
            if let selectedUserCell = sender as? UserTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedUserCell)!
                let selectedUser = users[indexPath.row]
                userViewController.user = selectedUser
            }
        } else if segue.identifier == "AddItem" {
            print("adding new meal")
        }
    }
    
    
    //MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        users = []
        page = 0
        self.loadingMore = false
        self.moreData = true
        self.api = PokeApi.instance
        self.alertMessage = AlertMessage.instance
        addedUsers = []
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        loadMore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell", forIndexPath: indexPath) as! UserTableViewCell
        cell.emailLabel.text = users[indexPath.item].email
        cell.user = users[indexPath.item]
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //Delete the row from the source data
            api.deleteUser(users[indexPath.row], completionHandler: { errorMessage, deletedUser in
                dispatch_async(dispatch_get_main_queue(), {
                    if errorMessage != nil {
                        self.alertMessage.displayErrorMessage(errorMessage!, ViewController: self)
                    } else {
                        self.users.removeAtIndex(indexPath.row)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    }
                })
            })
        } else if editingStyle == .Insert {
            //Create new instance of the appropriate class, insert it into the array, and add a new row to the table View
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func loadMore(){
        self.page! += 1
        api.getTenUsers(page, completionHandler: { errorMessage, newUsers in
            if errorMessage != nil {
                self.alertMessage.displayErrorMessage(errorMessage!, ViewController: self)
            }
            if newUsers?.count == 0 {
                self.moreData = false
                return
            }
            
            var varNewUsers = newUsers
            
            for (index, nUsers) in (varNewUsers?.enumerate())! {
                for aUsers in self.addedUsers! as [String] {
                    if nUsers.id == aUsers {
                        varNewUsers?.removeAtIndex(index)
                    }
                }
            }
            
            self.users! += varNewUsers!
            //reload tableView data not asynch (doing this asynch causes the tableview to sometimes update before the new data is available)
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

