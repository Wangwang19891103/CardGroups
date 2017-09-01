//
//  GroupTableViewController.swift
//  CardGroups
//
//  Created by Wang on 7/12/16.
//  Copyright © 2016 Wang. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {
    
    
    let data = GroupData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIApplication.sharedApplication().statusBarHidden=true;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PlacesTableViewCell
        let entry = data.places[indexPath.row]
        cell.layer.cornerRadius = 15
        cell.starImg.highlighted = entry.rate
        cell.groupLbl.text = entry.groupname
        cell.headLbl.text = entry.heading
        cell.contentLbl.text = entry.content
        cell.passButton.tag = indexPath.row    
    
        return cell
    }
//    @IBAction func clickPass(sender: AnyObject) {
//        SharingManager.sharedInstance.groupID = sender.tag+1
//        
//    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        SharingManager.sharedInstance.groupID = Int32(indexPath.row)
//    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "cards"){
            
            let btn = sender as! UIButton
            print(btn.tag)
            SharingManager.sharedInstance.groupID = btn.tag + 1
            let vc = segue.destinationViewController as! PhotoStreamViewController
            vc.groupID = btn.tag + 1
            
        }
    }
    

}
