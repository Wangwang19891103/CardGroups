//
//  Cardsviewcontroller.swift
//  CardGroups
//
//  Created by Wang on 7/12/16.
//  Copyright © 2016 Wang. All rights reserved.
//

import UIKit
import Firebase

class Cardsviewcontroller: UIViewController {
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var favoriteState: UIImageView!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var imageState: UIImageView!
    @IBOutlet weak var descrptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var shardState: UIImageView!
    @IBOutlet weak var clipNumber: UILabel!
    @IBOutlet weak var videoplayIMG: UIImageView!
    @IBOutlet weak var clippingState: UIImageView!
    @IBOutlet weak var shareing: UIButton!

    var firebase: FIRDatabaseReference!
    var profileID:String = ""
    var clipState: Bool = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        self.loadCard()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Cardsviewcontroller.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        profileID = SharingManager.sharedInstance.profileID
        firebase = FIRDatabase.database().reference()
        self.loadCard()
//        UIApplication.sharedApplication().statusBarHidden=true;
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func gotoBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func favoriteClick(sender: AnyObject) {
        
        let click_title = Card.sharedInstance.title
        let favoriteState = Card.sharedInstance.favorite
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if favoriteState {
            
            self.favoriteState.image = UIImage(named: "Heart Off Icon")
            self.firebase.child(profileID).child(click_title).updateChildValues(["favorite": false])
            
        }else {
            
            self.favoriteState.image = UIImage(named: "Heart On Icon")
            self.firebase.child(profileID).child(click_title).updateChildValues(["favorite": true])
            
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    @IBAction func clippingClick(sender: AnyObject) {
        
        let click_title = Card.sharedInstance.title
        let clip_count = Int(self.clipNumber.text!)!
        print("clip_count")
        print(clip_count)
        clipState = !clipState
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if clipState {
            
            print(clipState)
            self.clippingState.image = UIImage(named: "Clip On Icon")
            self.firebase.child("cards").child(click_title).updateChildValues(["clipping_count":clip_count+1])
            self.firebase.child("Christian Bale").child(click_title).updateChildValues(["clipping_count":clip_count+1])
            self.firebase.child("Mary Cristine").child(click_title).updateChildValues(["clipping_count":clip_count+1])
            self.firebase.child("Sophia Linn").child(click_title).updateChildValues(["clipping_count":clip_count+1])
            self.firebase.child("Edward Vince").child(click_title).updateChildValues(["clipping_count":clip_count+1])
            self.firebase.child(profileID).child(click_title).updateChildValues(["clipping": true])
            self.clipNumber.text = String(clip_count + 1)
            
        } else {
            print(clipState)
            self.clippingState.image = UIImage(named: "Clip Off Icon")
            self.firebase.child("cards").child(click_title).updateChildValues(["clipping_count":clip_count-1])
            self.firebase.child("Christian Bale").child(click_title).updateChildValues(["clipping_count":clip_count-1])
            self.firebase.child("Mary Cristine").child(click_title).updateChildValues(["clipping_count":clip_count-1])
            self.firebase.child("Sophia Linn").child(click_title).updateChildValues(["clipping_count":clip_count-1])
            self.firebase.child("Edward Vince").child(click_title).updateChildValues(["clipping_count":clip_count-1])
            self.firebase.child(profileID).child(click_title).updateChildValues(["clipping": false])
            self.clipNumber.text = String(clip_count - 1)
            
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    @IBAction func shareClick(sender: AnyObject) {
        TitleLabel.resignFirstResponder()
        if (TitleLabel.text == "") {
            displayAlert("Warning", message: "Enter something in the label")
        } else {
            displayShareSheet(TitleLabel.text!)
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displayShareSheet(shareContent: String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
        
        
  
    func loadCard() {        
        
        
        if Card.sharedInstance.type == "image" {
            videoplayIMG.hidden = true
        }
        self.TitleLabel.text = Card.sharedInstance.title
        self.priceLabel.text = Card.sharedInstance.price
        self.descrptionLabel.text = Card.sharedInstance.description
        self.ownerImage.image = UIImage(named: Card.sharedInstance.owner+".png")
        self.imageState.image = Card.sharedInstance.image
        if Card.sharedInstance.favorite {
            self.favoriteState.image = UIImage(named: "Heart On Icon")
        }else {
            self.favoriteState.image = UIImage(named: "Heart Off Icon")
        }
        if Card.sharedInstance.price == "" {
            self.clipNumber.hidden = true
        } else {
            self.clipNumber.hidden = false
            self.clipNumber.text = String(Card.sharedInstance.clipNumber)
            if Card.sharedInstance.clipping {
                self.clippingState.image = UIImage(named: "Clip On Icon")
                clipState = true
            } else {
                self.clippingState.image = UIImage(named: "Clip Off Icon")
                clipState = false
            }
        }
    }
        
        
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        print(sender)
        if(segue.identifier == "imageZoom"){
            
//            let imageBtn = sender as! UIButton
            
            let vc = segue.destinationViewController as! CardZoomViewController
            vc.image = Card.sharedInstance.image
            vc.medioType = Card.sharedInstance.type
            vc.medioURL = Card.sharedInstance.mediaurl
            
        }
    }
}
