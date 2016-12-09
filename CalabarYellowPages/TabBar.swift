//
//  TabBar.swift
//  CalabarYellowPages
//
//  Created by Smile Egbai on 12/8/16.
//  Copyright © 2016 calabarpages. All rights reserved.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = NSUserDefaults.standardUserDefaults()
        
        let loggedIn = "loggedIn"
        
        if preferences.objectForKey(loggedIn) == nil {
            //  Doesn't exist
            let logginControl:Login = self.storyboard?.instantiateViewControllerWithIdentifier("login") as! Login
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                self.presentViewController(logginControl, animated: true, completion: nil)
            })
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
