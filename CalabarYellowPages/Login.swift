//
//  Login.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 12/8/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class Login: UIViewController, FBSDKLoginButtonDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() == nil)
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }else{
            
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
               self.returnUserData()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,gender"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                let preferences = NSUserDefaults.standardUserDefaults()
                
                let currentLevelKey = "loggedIn"
                
                let currentLevel = 1
                    preferences.setInteger(currentLevel, forKey: currentLevelKey)
                
                //  Save to disk
                let didSave = preferences.synchronize()
                
                if !didSave {
                    //  Couldn't save (I've never seen this happen in real world testing)
                }
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("first_name") as! NSString
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
                let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: configuration)
                let params:[String: AnyObject] = [
                    "email" : userEmail,
                    "name" : userName ]
                
                let url = NSURL(string:DataModel.Url + "facebookLogin")
                let request = NSMutableURLRequest(URL: url!)
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.HTTPMethod = "POST"
               // var err: NSError?
                do{
                    try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
                    
                    let task = session.dataTaskWithRequest(request) {
                        data, response, error in
                        
                        if let httpResponse = response as? NSHTTPURLResponse {
                            if httpResponse.statusCode != 200 {
                                print("response was not 200: \(response)")
                                return
                            }
                        }
                        if (error != nil) {
                            print("error submitting request: \(error)")
                            return
                        }
                        
                        // handle the data of the successful response here
                        
                    }
                    task.resume()
                }
                
                catch{
                    
                }
                
                let logginControl:TabBar = self.storyboard?.instantiateViewControllerWithIdentifier("main") as! TabBar
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    self.presentViewController(logginControl, animated: true, completion: nil)
                })
                
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
