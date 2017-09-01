//
//  RoundedCornersView.swift
//  RWDevCon
//
//  Created by Wang on 7/10/2016.
//  Copyright © 2016 Wang All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornersView: UIView {
  
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }
  
}
