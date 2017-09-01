//
//  Photo.swift
//  RWDevCon
//
//  Created by Wang on 07/11/2016.
//  Copyright (c) 2015 Wang. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

class Photo {
     
    var title: String
    var price: String
    var description: String
    var owner: String
    var image: UIImage
    var favorite: Bool
    var clipNumber: Int
    var group: Int
    var type: String
    var mediourl: String
    var imageurl:String
    var clipping:Bool
    var createdate: String
  
    init(title: String, price: String, description: String, owner: String, image: UIImage, favorite: Bool, clipNumber: Int, group: Int, type: String, mediourl: String, imageurl: String, clipping: Bool, createdate: String) {
        self.title = title
        self.price = price
        self.description = description
        self.owner = owner
        self.image = image
        self.favorite = favorite
        self.clipNumber = clipNumber
        self.group = group
        self.type = type
        self.mediourl = mediourl
        self.imageurl = imageurl
        self.clipping = clipping
        self.createdate = createdate
        
    }
  
    convenience init(dictionary: NSDictionary) {
        let title = dictionary["title"] as? String
        let description = dictionary["description"] as? String
        let owner = dictionary["profile_id"]  as! String
        let price = dictionary["card_price"] as? String
        let mediourl = dictionary["media_url"] as? String
        let imageurl = dictionary["image_url"] as? String
        let clipNumber = dictionary["clipping_count"] as? Int
        let type = dictionary["type"] as? String
        let createdate = dictionary["creation_date"] as? String
    
        let decodedData = NSData(base64EncodedString: imageurl!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let image = (UIImage(data: decodedData!)?.decompressedImage)!

       
        
    
        let favorite = dictionary["favorite"] as? Bool
        let clipping = dictionary["clipping"] as? Bool
        let group = dictionary["group_id"] as? Int
        self.init(title: title!, price: price!, description: description!, owner: owner, image: image, favorite: favorite!, clipNumber: clipNumber!, group: group!, type: type!, mediourl: mediourl!, imageurl: imageurl!, clipping: clipping!, createdate: createdate!)
        
        
    }
    
    //this fucntion returns photo's context height
    func heightForComment(font: UIFont, width: CGFloat) -> CGFloat {
        let recttitle = NSString(string: title).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(recttitle.height)
    }
    func heightForPrice(font: UIFont, width: CGFloat) -> CGFloat {
        let rectprice = NSString(string: price).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rectprice.height)
    }
    func heightForDescription(font: UIFont, width: CGFloat) -> CGFloat {
        let rectdescription = NSString(string: description).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rectdescription.height)
    }
    
  
}
