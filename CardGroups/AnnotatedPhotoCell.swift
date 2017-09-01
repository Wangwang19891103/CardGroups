//
//  AnnotatedPhotoCell.swift
//  RWDevCon
//
//  Created by Wang on 7/10/2016.
//  Copyright © 2016 Wang All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var descriptionlbl: UILabel!
    @IBOutlet weak var ownerlbl: UILabel!
    @IBOutlet weak var markimg: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var clipNumber: UILabel!
    @IBOutlet weak var clippingBtn: UIButton!
    @IBOutlet weak var videoplayIMG: UIImageView!
    @IBOutlet private weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
//    @IBOutlet weak var priceConstraint: NSLayoutConstraint!
//    @IBOutlet weak var titleConstraint: NSLayoutConstraint!
//    @IBOutlet weak var ownerConstraint: NSLayoutConstraint!
//    @IBOutlet weak var desConstraint: NSLayoutConstraint!

var photo: Photo? {
    didSet {
      if let photo = photo {
            imageView.image = photo.image
            titlelbl.text = photo.title
            pricelbl.text = photo.price
            descriptionlbl.text = photo.description
            ownerlbl.text = photo.owner
        let user = SharingManager.sharedInstance.profileID
        if photo.type == "image" {
            videoplayIMG.hidden = true
        }
        if photo.owner == user {
            clippingBtn.hidden = true
            favoriteBtn.hidden = true
            if photo.price != "" {
                clipNumber.hidden = false
                clipNumber.text = String(photo.clipNumber)
            }else {                
                clipNumber.hidden = true
            }
        } else {
            clippingBtn.hidden = false
            favoriteBtn.hidden = false
            if photo.favorite {
                favoriteBtn.setImage(UIImage(named: "Heart On Icon"), forState: .Normal)
            }else {
                favoriteBtn.setImage(UIImage(named: "Heart Off Icon"), forState: .Normal)
            }
            
            if photo.price != "" {
                clipNumber.hidden = false
                clipNumber.text = String(photo.clipNumber)
                if photo.clipping {
                    clippingBtn.setImage(UIImage(named: "Clip On Icon"), forState: .Normal)
                }else {
                    clippingBtn.setImage(UIImage(named: "Clip Off Icon"), forState: .Normal)
                }
            }else {
                clippingBtn.hidden = true
                clipNumber.hidden = true
            }
        }
        
        
        
      }
    }
  }
  
  override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
    super.applyLayoutAttributes(layoutAttributes)
    if let attributes = layoutAttributes as? PinterestLayoutAttributes {
        imageViewHeightLayoutConstraint.constant = attributes.photoHeight
//        titleConstraint.constant = attributes.photoWidth
//        priceConstraint.constant = attributes.photoWidth
//        desConstraint.constant = attributes.photoWidth-10
//        ownerConstraint.constant = attributes.photoWidth
    }
  }
}
