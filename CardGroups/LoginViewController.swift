//
//  LoginViewController.swift
//  CardGroups
//
//  Created by Wang on 7/23/16.
//  Copyright © 2016 Wang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIApplication.sharedApplication().statusBarHidden=true;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func christianLogin(sender: AnyObject) {
        
        SharingManager.sharedInstance.profileID = "Christian Bale"
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func edwardLogin(sender: AnyObject) {
        SharingManager.sharedInstance.profileID = "Edward Vince"
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func maryLogin(sender: AnyObject) {
        SharingManager.sharedInstance.profileID = "Mary Cristine"
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func sophiaLogin(sender: AnyObject) {
        SharingManager.sharedInstance.profileID = "Sophia Linn"
        self.dismissViewControllerAnimated(true, completion: nil)
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
