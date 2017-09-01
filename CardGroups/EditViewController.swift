//
//  EditViewController.swift
//  CardGroups
//
//  Created by Wang on 7/18/16.
//  Copyright © 2016 Wang. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var owner: UIImageView!
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var sharingBtn: UIImageView!
    
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var clipping: UIButton!
    @IBOutlet weak var trashbtn: UIButton!
    @IBOutlet weak var canceled: UIButton!
    @IBOutlet weak var finishedBtn: UIButton!
    @IBOutlet weak var shareing: UIButton!

    var firebase: FIRDatabaseReference!
    var cardState = "available"
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var type: String = ""
    var mediaurl: String = ""
    
    var videoURL: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.loadCard()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        UIApplication.sharedApplication().statusBarHidden=true;
        
        firebase = FIRDatabase.database().reference()
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func gotoBack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    @IBAction func finished(sender: AnyObject) {
        cardState = "finished"
        
    }
    @IBAction func cancled(sender: AnyObject) {
        cardState = "Cancled"
        
    }
    @IBAction func deleted(sender: AnyObject?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        firebase.child("cards").child(Card.sharedInstance.title).removeValue()
        firebase.child("Christian Bale").child(Card.sharedInstance.title).removeValue()
        firebase.child("Mary Cristine").child(Card.sharedInstance.title).removeValue()
        firebase.child("Sophia Linn").child(Card.sharedInstance.title).removeValue()
        firebase.child("Edward Vince").child(Card.sharedInstance.title).removeValue()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func shareClick(sender: AnyObject) {
        titleTxt.resignFirstResponder()
        if (titleTxt.text == "") {
            displayAlert("Warning", message: "Enter something in the label")
        } else {
            displayShareSheet(titleTxt.text!)
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
    
    @IBAction func editCard(sender: AnyObject?) {
        let title = self.titleTxt.text
        let price = self.priceTxt.text
        let description = self.descriptionTxt.text
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeZone = NSTimeZone()
        
        let updateDate = dateFormatter.stringFromDate(date)
        
        let groupID = Card.sharedInstance.group
        let creatdate = Card.sharedInstance.createdate
        
        let profileID = SharingManager.sharedInstance.profileID
        
        let clipCount = Card.sharedInstance.clipNumber
        
        let favorite:Bool = false
        let clipping:Bool = false
        
        var data: NSData = NSData()
        if let image = imageView.image {
            data = UIImageJPEGRepresentation(image, 0.1)!
        }
        let imageurl = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let card: NSDictionary = ["title":title as! AnyObject,
                                  "description":description ,
                                  "type":type ,
                                  "image_url": imageurl,
                                  "media_url": videoURL,
                                  "card_price":price!,
                                  "card_status":cardState,
                                  "creation_date":creatdate,
                                  "update_date":updateDate,
                                  "profile_id":profileID,
                                  "group_id":groupID,
                                  "favorite":favorite,
                                  "clipping":clipping,
                                  "clipping_count":clipCount]
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //add firebase child node
        let child = ["/cards/\(title!)": card,
                     "/Christian Bale/\(title!)": card,
                     "/Edward Vince/\(title!)": card,
                     "/Mary Cristine/\(title!)": card,
                     "/Sophia Linn/\(title!)": card]
        
        
        // Write data to Firebase
        firebase.updateChildValues(child)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.performSegueWithIdentifier("card", sender: self)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func loadCard() {
        
        self.type = Card.sharedInstance.type
        self.videoURL = Card.sharedInstance.mediaurl
        self.titleTxt.text = Card.sharedInstance.title
        self.priceTxt.text = Card.sharedInstance.price
        self.imageView.image = Card.sharedInstance.image
        self.descriptionTxt.text = Card.sharedInstance.description
        self.clipping.setTitle(String(Card.sharedInstance.clipNumber), forState: .Normal)
        self.owner.image = UIImage(named: Card.sharedInstance.owner+".png")
    }
    
    // MARK:- UIImagePickerControllerDelegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType:String = info[UIImagePickerControllerMediaType] as! String
        if mediaType == "public.image" {
            imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            type = "image"
            
        } else if mediaType == "public.movie" {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            imageView.image = previewImageFromVideo(videoURL)!
            
            
            videoUploadController(videoURL)
            
            type = "video"
        }
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    /*upload video file*/
    func videoUploadController(mediaURL: NSURL)
    {
        let fileName = mediaURL.lastPathComponent
        let metadata = FIRStorageMetadata()
        metadata.contentType = "video/mov"
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        videoURL = "video/"+fileName!
        let riversRef = storageRef.child(videoURL)
        riversRef.putFile(mediaURL, metadata: metadata, completion: {(metadata, error) in
            if (error != nil) {
                NSLog("Upload error")
            } else {
                let downloadURL = metadata!.downloadURL()
                print    ("DownURL--->"+(downloadURL?.absoluteString)!)
            }
        })
        
    }
    
    // MARK:- Add Picture
    @IBAction func imageTapped(sender: AnyObject) {
        

        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion:nil)

        
    }
    
    func previewImageFromVideo(url:NSURL) -> UIImage? {
        let asset = AVAsset(URL:url)
        let imageGenerator = AVAssetImageGenerator(asset:asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value,2)
        
        do {
            let imageRef = try imageGenerator.copyCGImageAtTime(time, actualTime: nil)
            return UIImage(CGImage: imageRef)
        } catch {
            return nil
        }
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
