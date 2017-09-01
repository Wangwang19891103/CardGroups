//
//  CardZoomViewController.swift
//  CardGroups
//
//  Created by Wang on 7/12/16.
//  Copyright © 2016 Wang. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase


class CardZoomViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var imageZoom: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageclick: UIButton!
    
    var image = UIImage()
    var medioURL = String()
    var medioType = String()
    var videoURL = NSURL()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    } 
    
        
    override func viewWillAppear(animated: Bool) {
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        UIApplication.sharedApplication().statusBarHidden=true;
        self.imageZoom.image = image
        if medioType == "image" {
            self.imageclick.hidden = true
        }
        if medioType == "video" {
            self.progressBarDisplayer("Downloading video", true)
        }
        
        /*Downloading file from firebase storeage*/
        let storageRef = FIRStorage.storage().reference()
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0]
        let filePath = "\(documentDirectory)/myvideo.MOV"
        let downloadTask = storageRef.child(medioURL).writeToFile(NSURL.init(fileURLWithPath: filePath), completion: { (url, error) in
            
            if let error = error {
                print("Error downloading:\(error)")
                return
            } else {
                print("Download Succeeded!")
                self.videoURL = url!
                
            }
            
        })
        downloadTask.observeStatus(.Success, handler: { snapshot in
            self.messageFrame.removeFromSuperview()
        })
        
    }
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 245, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 100, y: view.frame.midY - 25 , width: 215, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.5)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    @IBAction func gotoBack(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func imageClick(sender: AnyObject) {
        
        let player = AVPlayer(URL: videoURL)
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.presentViewController(playerViewController, animated: true){
            playerViewController.player!.play()
            
        }
        
        
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.imageclick.enabled = true
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageZoom
    }
}
