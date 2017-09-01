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

class PhotoStreamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate{
  
    var photos = [Photo]()
    
    var searchResults = [Photo]()
    var groupID: Int = 0
    var profileID:String = ""
    var firebase: FIRDatabaseReference!
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
     
    @IBOutlet weak var pcollectionview: UICollectionView!
    
    @IBOutlet weak var searchBar:UISearchBar!
    
    var isFilltered:Bool = false
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PhotoStreamViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
    
    
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
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.progressBarDisplayer("Downloading Cards", true)
        

        self.tabBarController?.tabBar.hidden = true
//        UIApplication.sharedApplication().statusBarHidden=true;
//        groupID = SharingManager.sharedInstance.groupID
//        print("groupID")
//        print(groupID)
        profileID = SharingManager.sharedInstance.profileID
        switch groupID {
        case 1:
            self.navigationItem.title = "Kids, Education"
        case 2:
            self.navigationItem.title = "Work"
        case 3:
            self.navigationItem.title = "Sales"
        default:
            print("group not exist")
            
        }
     
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        firebase = FIRDatabase.database().reference()
        print(firebase)
        firebase.child(profileID).queryOrderedByChild("group_id").queryEqualToValue(groupID).observeEventType(.Value, withBlock: { snapshot in
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
        print(photos.count)
        
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
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        UIApplication.sharedApplication().statusBarHidden=false;
    }
    
    @IBAction func cellclick(sender:AnyObject) {
        
        let destinationCard = photos[sender.tag]
        
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
        
        if destinationCard.owner == profileID {
            self.performSegueWithIdentifier("edit", sender: self)
            
        } else {
            self.performSegueWithIdentifier("detail", sender: self)
        }
    }
    @IBAction func clippingClick(sender: AnyObject) {
        print(sender.tag)
        let click_title = photos[sender.tag].title
        let clip_count = photos[sender.tag].clipNumber
        print("clip_count")
        print(clip_count)
        let clipState = photos[sender.tag].clipping
            
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if !(clipState) {
                
            print(clipState)
            (sender as! UIButton).setImage(UIImage(named: "Clip On Icon"), forState: .Normal)
            self.firebase.child("cards").child(click_title).updateChildValues(["clipping_count":clip_count+1])
            self.firebase.child("Christian Bale").child(click_title).updateChildValues(["clipping_count":clip_count+1])
            self.firebase.child("Mary Cristine").child(click_title).updateChildValues(["clipping_count":clip_count+1])
            self.firebase.child("Sophia Linn").child(click_title).updateChildValues(["clipping_count":clip_count+1])
            self.firebase.child("Edward Vince").child(click_title).updateChildValues(["clipping_count":clip_count+1])
            self.firebase.child(profileID).child(click_title).updateChildValues(["clipping": true])
            photos[sender.tag].clipping = true
            photos[sender.tag].clipNumber = clip_count+1
            self.pcollectionview.collectionViewLayout.invalidateLayout()
            pcollectionview.reloadData()
                    
        } else {
            print(clipState)
            (sender as! UIButton).setImage(UIImage(named: "Clip Off Icon"), forState: .Normal)
            self.firebase.child("cards").child(click_title).updateChildValues(["clipping_count":clip_count-1])
            self.firebase.child("Christian Bale").child(click_title).updateChildValues(["clipping_count":clip_count-1])
            self.firebase.child("Mary Cristine").child(click_title).updateChildValues(["clipping_count":clip_count-1])
            self.firebase.child("Sophia Linn").child(click_title).updateChildValues(["clipping_count":clip_count-1])
            self.firebase.child("Edward Vince").child(click_title).updateChildValues(["clipping_count":clip_count-1])
            self.firebase.child(profileID).child(click_title).updateChildValues(["clipping": false])
            photos[sender.tag].clipping = false
            photos[sender.tag].clipNumber = clip_count-1
            self.pcollectionview.collectionViewLayout.invalidateLayout()
            pcollectionview.reloadData()
            
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.pcollectionview.reloadData()
    }
        
        
    
    @IBAction func favoriteClick(sender: AnyObject) {
        //        print(sender.tag)
        //        print(photos[sender.tag].title)
        let click_title = photos[sender.tag].title
        let favoriteState = photos[sender.tag].favorite
        
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if favoriteState {
                    
            (sender as! UIButton).setImage(UIImage(named: "Heart Off Icon"), forState: .Normal)
            self.firebase.child(profileID).child(click_title).updateChildValues(["favorite": false])
            photos[sender.tag].favorite = false
            self.pcollectionview.collectionViewLayout.invalidateLayout()
            pcollectionview.reloadData()
                    
        }else {
            (sender as! UIButton).setImage(UIImage(named: "Heart On Icon"), forState: .Normal)
            self.firebase.child(profileID).child(click_title).updateChildValues(["favorite": true])
            photos[sender.tag].favorite = true
            self.pcollectionview.collectionViewLayout.invalidateLayout()
            pcollectionview.reloadData()
        }
       
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if(segue.identifier == "detail"){
//            
//            let cell = sender as! AnnotatedPhotoCell
//            print(cell.tag)
//            let vc = segue.destinationViewController as! Cardsviewcontroller
//            if isFilltered {
//                vc.card = searchResults[cell.tag]
//            }else {
//                 vc.card = photos[cell.tag]
//            }
//          
//            
//        }
//    }
    
    
    

}


extension PhotoStreamViewController {
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFilltered {
            return searchResults.count
        } else {
            return photos.count
        }
        
    }
  
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell
        if isFilltered {
            cell.photo = searchResults[indexPath.item]
            cell.tag = indexPath.item
            cell.favoriteBtn.tag = indexPath.item
            cell.clippingBtn.tag = indexPath.item
        } else {
            cell.photo = photos[indexPath.item]
            cell.tag = indexPath.item
            cell.favoriteBtn.tag = indexPath.item
            cell.clippingBtn.tag = indexPath.item
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let destinationCard: Photo!
        if isFilltered {
            destinationCard = searchResults[indexPath.item]
        } else {
            destinationCard = photos[indexPath.item]
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
        
        if destinationCard.owner == profileID {
            self.performSegueWithIdentifier("edit", sender: self)
            
        } else {
            self.performSegueWithIdentifier("detail", sender: self)
        }

    }
  
}

extension PhotoStreamViewController : PinterestLayoutDelegate {
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
        let annotationHeaderHeight = CGFloat(24)
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

