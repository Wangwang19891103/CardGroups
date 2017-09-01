//
//  UIImage+Decompression.swift
//  RWDevCon
//
//  Created by Wang on 09/03/2015.
//  Copyright © 2016 Wang. All rights reserved.
//

import UIKit

extension UIImage {
  
  var decompressedImage: UIImage {
    UIGraphicsBeginImageContextWithOptions(size, true, 0)
    drawAtPoint(CGPointZero)
    let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return decompressedImage
  }
  
}
