//
//  UserTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by orlando arzola on 25.08.16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {
    
    var usernames = [String]()
    var userIds = [String]()
    var isFollowing = [String: Bool]()
    
    
    
    
    @IBAction func logout(_ sender: AnyObject) {
        
        PFUser.logOut()
        performSegue(withIdentifier: "showLogin", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsers()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(UserTableViewController.getUsers), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Methods 
    
    func getUsers (){
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            if error != nil {
                
            } else {
                
                if let users = objects {
                    
                    for object in users {
                        
                        if let user = object as? PFUser {
                            
                            if user.objectId != PFUser.current()?.objectId{
                                
                                self.usernames.append(user.username!)
                                self.userIds.append(user.objectId!)
                                
                                let query = PFQuery(className: "Followers")
                                
                                query.whereKey("follower", equalTo: (PFUser.current()?.objectId)!)
                                
                                query.whereKey("following", equalTo: user.objectId!)
                                
                                query.findObjectsInBackground(block: { (objects, error) in
                                    
                                    self.refreshControl?.endRefreshing()
                                    if let objects = objects {
                                        
                                        if objects.count > 0 {
                                            
                                            self.isFollowing[user.objectId!] = true
                                        } else {
                                            
                                            self.isFollowing[user.objectId!] = false
                                        }
                                        
                                        if self.isFollowing.count == self.usernames.count {
                                            
                                            
                                            self.tableView.reloadData()
                                            
                                            
                                        }
                                        
                                        
                                    }
                                })
                            }
                        }
                    }
                }
            }
            
            
        })

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        cell.textLabel?.text = usernames[indexPath.row]
        
        if isFollowing[userIds[indexPath.row]]! {
            
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }

        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        
        if !(isFollowing[userIds[indexPath.row]]!) {
        
        isFollowing[userIds[indexPath.row]] = true
        cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        let following = PFObject(className: "Followers")
        
        following["follower"] = PFUser.current()?.objectId
        
        following["following"] = userIds[indexPath.row]
        
        following.saveInBackground()
            
        } else {
            
            isFollowing[userIds[indexPath.row]] = false
            
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            let query = PFQuery(className: "Followers")
            
            query.whereKey("follower", equalTo: (PFUser.current()?.objectId)!)
            query.whereKey("following", equalTo: userIds[indexPath.row])
            
            query.findObjectsInBackground(block: { (objects, error) in
                
                if error != nil {
                    
                    print("This is the error\(error)")
                } else {
                    
                    if let objects = objects {
                    
                    for object in objects {
                        
                        object.deleteInBackground()
                    }
                }
                    
                }
                
            })
        }
    }

 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
