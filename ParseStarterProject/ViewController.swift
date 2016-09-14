/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupMode = true
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signupOrLogin: UIButton!
    
    @IBOutlet weak var modiferButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    @IBAction func login(_ sender: AnyObject) {
        
        
        if signupMode {
            signupOrLogin.setTitle("Log In", for: [])
            modiferButton.setTitle("Sign Up", for: [])
            
            messageLabel.text = "Don't have an account?"
            
            signupMode = false
            
            
        } else {
            
            signupOrLogin.setTitle("Sign Up", for: [])
            modiferButton.setTitle("Log In", for: [])
            
            messageLabel.text = "Already have an account?"
            
            signupMode = true
            
        }
    }
    @IBAction func signup(_ sender: AnyObject) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            createAlert(title: "Error in form", message: "Please enter an email and password")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
                
            
            if signupMode {
                
                // Sign Up
                
                let user = PFUser()
                
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                    
                    if error != nil {
                        
                        if let error = error as NSError? {
                            
                            self.createAlert(title: "Signup Error", message: error.userInfo["error"] as! String)
                        }
                        
                        
                    } else {
                        
                        print("user signed up")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                        
                    }
                })
            } else {
                
                // Login mode
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                    
                    if  error != nil {
                        
                        if let error = error as NSError? {
                            
                            self.createAlert(title: "Login Error", message: error.userInfo["error"] as! String)
                        }
                    } else {
                        
                        print("user logged in")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
                
            }
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        
         save object
        let testObject = PFObject(className: "User1")
        
        testObject["name"] = "ola"
        
        testObject.saveInBackground { (success, error) -> Void in
            
            // added test for success 11th July 2016
            
            if success {
                
                print("Object has been saved.")
                
            } else {
                
                if error != nil {
                    
                    print (error)
                    
                } else {
                    
                    print ("Error")
                }
                
            }
            
        }
        
        */
        
        
/*
        // update object
            let query = PFQuery(className:"User1")
        
        query.getObjectInBackground(withId: "HRMagLdPuR") { (object, error) in
            
            if error != nil {
                print(error)
            } else if let object = object {
                object["name"] = "hase"
                
                object.saveInBackground(block: { (succes, error) -> Void in
                    
                    if error != nil {
                        
                        print(error)
                    } else {
                        
                        print("object updated!")
                        
                    }
                })
            }
        }
 
 */
        
      
        
        // find object
 
       /*
        let query = PFQuery(className:"User1")
        
        query.whereKey("name", equalTo:"ola")
        
        query.findObjectsInBackground {(objects, error) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print("esto es el objectId: \(object.objectId)")
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
 */
 
 

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAlert (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
