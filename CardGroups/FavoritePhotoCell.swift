//
//  FavoritePhotoCell.swift
//  CardGroups
//
//  Created by Wang on 7/27/16.
//  Copyright © 2016 Wang. All rights reserved.
//
import UIKit
import Foundation
class FavoritePhotoCell: UICollectionViewCell {
    

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
    @IBOutlet weak var group: UIButton!
    var photo: Photo? {
        
        didSet {
            if let photo = photo {
                imageView.image = photo.image
                titlelbl.text = photo.title
                pricelbl.text = photo.price
                descriptionlbl.text = photo.description
                ownerlbl.text = photo.owner
                if photo.favorite {
                    favoriteBtn.setImage(UIImage(named: "Heart On Icon"), forState: .Normal)
                }else {
                    favoriteBtn.setImage(UIImage(named: "Heart Off Icon"), forState: .Normal)
                }
                if photo.type == "image" {
                    videoplayIMG.hidden = true
                }
                if photo.price != "" {
                    clippingBtn.hidden = false
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
                switch photo.group {
                case 1:
                    group.setTitle("Kids, Education", forState: .Normal)
                case 2:
                    group.setTitle("Work", forState: .Normal)
                case 3:
                    group.setTitle("Sales", forState: .Normal) 
                default:
                    print("group not exist")
                    
                }
                
            }
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
            
        }
    }
}
