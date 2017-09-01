//
//  Card.swift
//  CardGroups
//
//  Created by Wang on 8/5/16.
//  Copyright © 2016 Wang. All rights reserved.
//

import Foundation
import UIKit

class Card {
    
    static let sharedInstance = Card()
    
    var title: String = ""
    var price: String = ""
    var description: String = ""
    var owner: String = ""
    var image: UIImage!
    var favorite: Bool = false
    var clipNumber: Int = 0
    var group: Int = 0
    var type: String = ""
    var mediaurl: String = ""
    var imageurl:String = ""
    var clipping:Bool = false
    var createdate: String = ""
    var updatedate: String = ""
    
}
