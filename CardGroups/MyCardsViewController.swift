//
//  PhotoStreamViewController.swift
//  RWDevCon
//
//  Created by Wang on 16/07/2016.
//  Copyright © 2016 Wang.  All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class MyCardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate{
    
    var photos = [Photo]()
    var searchResults = [Photo]()
    var owner = String()
    var firebase: FIRDatabaseReference!
    var isFilltered = false
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    @IBOutlet weak var pcollectionview: UICollectionView!
   
    @IBOutlet weak var searchBar:UISearchBar!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pcollectionview.delegate = self
        
        pcollectionview.dataSource = self
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        // Set the PinterestLayout delegate
        if let layout = pcollectionview?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        //collectionView!.backgroundColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        pcollectionview!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyCardsViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
    }
  
    override func viewWillAppear(animated: Bool) {
        self.progressBarDisplayer("Downloading Cards", true)
        
        owner = SharingManager.sharedInstance.profileID
//        UIApplication.sharedApplication().statusBarHidden=true;
   
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        firebase = FIRDatabase.database().reference()
        firebase.child("cards").queryOrderedByChild("profile_id").queryEqualToValue(owner).observeEventType(.Value, withBlock: { snapshot in
            self.photos = []
            for item in snapshot.children {
                
                let child = item as! FIRDataSnapshot
                let dict = child.value as! NSDictionary
                
                let photo = Photo(dictionary: dict )
                
                self.photos.append(photo)
               
                
            }
            self.messageFrame.removeFromSuperview()
            self.pcollectionview.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
//        print(photos.count)
//        self.pcollectionview.reloadData()
        
        
    }
    
    
    
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
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    @IBAction func cliclkSegment(sender: AnyObject) {
        
        switch (sender as! UISegmentedControl).selectedSegmentIndex {
        case 0:
            owner = SharingManager.sharedInstance.profileID
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            firebase = FIRDatabase.database().reference()
            firebase.child("cards").queryOrderedByChild("profile_id").queryEqualToValue(owner).observeEventType(.Value, withBlock: { snapshot in
                self.photos = []
                for item in snapshot.children {
                    
                    let child = item as! FIRDataSnapshot
                    let dict = child.value as! NSDictionary
                    
                    let photo = Photo(dictionary: dict )
                    
                    self.photos.append(photo)
                    
                }
                self.pcollectionview.collectionViewLayout.invalidateLayout()
                self.pcollectionview.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            print(photos.count)
//            self.pcollectionview.reloadData()
        case 1:
            owner = SharingManager.sharedInstance.profileID

            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            firebase = FIRDatabase.database().reference()
            firebase.child("cards").queryOrderedByChild("profile_id").queryEqualToValue(owner).observeEventType(.Value, withBlock: { snapshot in
                self.photos = []
                for item in snapshot.children {
                    
                    let child = item as! FIRDataSnapshot
                    let dict = child.value as! NSDictionary
                    if (dict["clipping_count"] as! Int) != 0 {
                        let photo = Photo(dictionary: dict )
                        
                        self.photos.append(photo)
                        self.pcollectionview.reloadData()
                    }
                    
                }
                self.pcollectionview.collectionViewLayout.invalidateLayout()
                self.pcollectionview.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            print(photos.count)
//            self.pcollectionview.reloadData()
        default:
            print("segment not exist")
        }

    }
    
    //search bar delegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text!.isEmpty {
            isFilltered = false
            searchBar.resignFirstResponder()
            self.pcollectionview.collectionViewLayout.invalidateLayout()
            pcollectionview.reloadData()
        } else {
            print(" search text %@ ",searchBar.text! as NSString)
            isFilltered = true
            searchResults.removeAll()
            for index in 0..<photos.count {
                
                let currentString = photos[index].title
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchResults.append(photos[index])
                }
                
            }
            self.pcollectionview.collectionViewLayout.invalidateLayout()
            pcollectionview.reloadData()
        }
        
        pcollectionview.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        print(sender)
        if(segue.identifier == "editing"){
            
            let cell = sender as! MycardsCell
            let destinationCard: Photo!
            if isFilltered {
                destinationCard = searchResults[cell.tag]
            }else {
                destinationCard = photos[cell.tag]
            }
            
            Card.sharedInstance.title = destinationCard.title
            Card.sharedInstance.price = destinationCard.price
            Card.sharedInstance.description = destinationCard.description
            Card.sharedInstance.owner = destinationCard.owner
            Card.sharedInstance.clipNumber = destinationCard.clipNumber
            Card.sharedInstance.type = destinationCard.type
            Card.sharedInstance.image = destinationCard.image
            Card.sharedInstance.imageurl = destinationCard.imageurl
            Card.sharedInstance.mediaurl = destinationCard.mediourl
            Card.sharedInstance.clipping = destinationCard.clipping
            Card.sharedInstance.favorite = destinationCard.favorite
            Card.sharedInstance.createdate = destinationCard.createdate
            Card.sharedInstance.group = destinationCard.group
            
        } else if(segue.identifier == "cards") {
            let group =  sender as! UIButton
            let vc = segue.destinationViewController as! PhotoStreamViewController
            vc.groupID = photos[group.tag].group
        }
    }
        
    
}


extension MyCardsViewController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFilltered {
            return searchResults.count
        } else {
            return photos.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MycardsCell", forIndexPath: indexPath) as! MycardsCell
        if isFilltered {
            cell.photo = searchResults[indexPath.item]
            cell.tag = indexPath.item
            cell.group.tag = indexPath.item
            
        } else {
            cell.photo = photos[indexPath.item]
            cell.tag = indexPath.item
            cell.group.tag = indexPath.item
            
        }
        return cell
    }
    
}

extension MyCardsViewController : PinterestLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth width:CGFloat) -> CGFloat {
        let photo :Photo!
        if isFilltered {
            photo = searchResults[indexPath.item]
        } else {
            photo = photos[indexPath.item]
        }
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRectWithAspectRatioInsideRect(photo.image.size, boundingRect)
        return rect.size.height
    }
    
    // 2. Returns the annotation size based on the text
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(4)
        let annotationHeaderHeight = CGFloat(44)
        let photo :Photo!
        if isFilltered {
            photo = searchResults[indexPath.item]
        } else {
            photo = photos[indexPath.item]
        }
        let font = UIFont(name: "AvenirNext-Regular", size: 12)!
        let titleFont = UIFont(name: "AvenirNext-DemiBold", size: 14)!
        let commentHeight = photo.heightForComment(titleFont, width: width)
        let priceHeight = photo.heightForPrice(font, width: width)
        let descriptionHeight = photo.heightForDescription(font, width: width)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + priceHeight + descriptionHeight + annotationPadding
        return height
    }
}

