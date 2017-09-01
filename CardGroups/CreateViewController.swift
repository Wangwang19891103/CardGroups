//
//  CreateViewController.swift
//  CardGroups
//
//  Created by Wang on 7/18/16.
//  Copyright © 2016 Wang. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ownerImage: UIImageView!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var priceText: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionText: UITextView!
    
        
    var firebase: FIRDatabaseReference!
    
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    var profileID: String = ""
    
    var groupID: Int = 0
    
    var videoURL: String = ""
    
    var type: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firebase = FIRDatabase.database().reference()
        profileID = SharingManager.sharedInstance.profileID
        self.ownerImage.image = UIImage(named: profileID+".png")
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    
    func dismissKeyboard() {
        view.endEditing(true)
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
    
    // MARK:- UIImagePickerControllerDelegate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType:String = info[UIImagePickerControllerMediaType] as! String
        if mediaType == "public.image" {
            imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            type = "image"
            
        } else if mediaType == "public.movie" {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            imageView.image = previewImageFromVideo(videoURL)!
            
            
            type = "video"
            
            videoUploadController(videoURL)
        }
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
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
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK:- Add Picture
    @IBAction func imageTapped(sender: AnyObject) {
        
//        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
//            imagePicker =  UIImagePickerController()
//            imagePicker.mediaTypes = ["public.image", "public.movie"]
//            imagePicker.delegate = self
//            imagePicker.sourceType = .Camera
//            
//            presentViewController(imagePicker, animated: true, completion: nil)
//        } else {
            imagePicker.allowsEditing = false
            imagePicker.mediaTypes = ["public.image", "public.movie"]
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion:nil)
//        }
    
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        UIApplication.sharedApplication().statusBarHidden=true;
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    
    @IBAction func createCard(sender: AnyObject) {
        
        let title = titleText.text
        let price = priceText.text
        let description = descriptionText.text
        
        var data: NSData = NSData()
        if let image = imageView.image {
            data = UIImageJPEGRepresentation(image, 0.1)!
        }
        let imageURL = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeZone = NSTimeZone()
        
        let createDate = dateFormatter.stringFromDate(date)
        
        groupID = SharingManager.sharedInstance.groupID
        
        let clipCount: Int = 0
        
        let favorite:Bool = false
        let clipping:Bool = false
        
        if(title == "") {
            let alert = UIAlertView(title: "Sorry", message: "User can not leave the Card view.\nPlease input Card title.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            let card: NSDictionary = ["title":title as! AnyObject,
                                      "description":description ,
                                      "type":type ,
                                      "image_url":imageURL,
                                      "media_url":videoURL,
                                      "card_price":price!,
                                      "card_status":"available",
                                      "creation_date":createDate,
                                      "update_date":"0",
                                      "profile_id":profileID,
                                      "group_id":groupID,
                                      "favorite":favorite,
                                      "clipping":clipping,
                                      "clipping_count":clipCount]

            //add firebase child node
            let child = ["/cards/\(title!)": card,
                         "/Christian Bale/\(title!)": card,
                         "/Edward Vince/\(title!)": card,
                         "/Mary Cristine/\(title!)": card,
                         "/Sophia Linn/\(title!)": card]
        
        
            // Write data to Firebase
            firebase.updateChildValues(child)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        
        
    }
    @IBAction func cancelCard(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
