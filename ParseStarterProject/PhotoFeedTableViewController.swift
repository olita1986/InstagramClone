//
//  PhotoFeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by orlando arzola on 26.08.16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class PhotoFeedTableViewController: UITableViewController {
    
    var photos = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let query1 = PFQuery(className: "Followers")
        
        query1.whereKey("follower", equalTo: (PFUser.current()?.objectId)!)
        
        query1.findObjectsInBackground( block: { (objects, error) in
            if (error != nil) {
                
                print("there is an error")
            } else {
                
                if let followers = objects {

                    
                    for object in followers {
                        
                        if let follower = object as? PFObject {
                            
                            let followedUser = follower["following"] as! String
                            
                            let query2 = PFQuery(className: "Posts")
                            
                            query2.whereKey("userId", equalTo: followedUser)
                           // query2.whereKey("userId", equalTo: (PFUser.current()?.objectId)!)
                            
                            query2.findObjectsInBackground(block: { (objects, error) in
                                
                                if let posts = objects {
                                    
                                    
                                    
                                    for object in  posts {
                                        
                                        
                                        self.photos.append(object)
                                        
                                        self.tableView.reloadData()
                                        
                                    }
                                }
                            })
                        }
                    }
                    
                }
            }
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return photos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PhotoFeedTableViewCell

        // Configure the cell...
        
        cell.commentLabel.text = photos[indexPath.row]["comment"] as? String
        
        if let image = photos[indexPath.row]["imageFile"] as? PFFile {
            
            
            
            image.getDataInBackground(block: { (data, error) in
                
                if let imageData = data {
                    
                    if let downloadedImage = UIImage(data: imageData) {
                    
                        cell.photoImageView.image = downloadedImage
                    }
                }
                
                
            })
            
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
