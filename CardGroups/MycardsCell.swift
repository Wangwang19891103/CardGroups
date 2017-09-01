//
//  MycardsCell.swift
//  CardGroups
//
//  Created by Wang on 7/27/16.
//  Copyright © 2016 Wang. All rights reserved.
//

import UIKit

class MycardsCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var descriptionlbl: UILabel!
    @IBOutlet weak var ownerlbl: UILabel!
    @IBOutlet weak var markimg: UIImageView!
    @IBOutlet weak var group: UIButton!
    @IBOutlet weak var clipNumber: UIButton!
    @IBOutlet weak var videoplayIMG: UIImageView!
    @IBOutlet private weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    
    
    var photo: Photo? {
        didSet {
            if let photo = photo {
                imageView.image = photo.image
                titlelbl.text = photo.title
                pricelbl.text = photo.price
                descriptionlbl.text = photo.description
                ownerlbl.text = photo.owner
                clipNumber.setTitle(String(photo.clipNumber), forState: .Normal)
                
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
                
                if photo.type == "image" {
                    videoplayIMG.hidden = true
                }
                
                if photo.price != "" {
                    
                    clipNumber.hidden = false
                    
                }else {
                    
                    clipNumber.hidden = true
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
