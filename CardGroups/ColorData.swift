//
//  ColorData.swift
//  CardGroups
//
//  Created by Wang on 7/13/16.
//  Copyright © 2016 Wang. All rights reserved.
//

import Foundation
import UIKit

class ColorData {
    class Entry {
        let color : UIColor
        let colorname : String
        let content : String
        init(color : UIColor, colorname : String, content : String) {
            self.color = color
            self.colorname = colorname
            self.content = content
        }
    }
    
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var colors = [
        Entry(color : ColorData.UIColorFromRGB(0x007AFF), colorname : "#007AFF", content : "Primary"),
        Entry(color : ColorData.UIColorFromRGB(0xD0021B), colorname : "#D0021B", content : "Attention"),
        Entry(color : ColorData.UIColorFromRGB(0x000000), colorname : "#000000", content : "Header/MainText"),
        Entry(color : ColorData.UIColorFromRGB(0x8C8C8C), colorname : "#8C8C8C", content : "SecondaryText"),
        Entry(color : ColorData.UIColorFromRGB(0xFFFFFF), colorname : "#FFFFFF", content : "MainBackground"),
        Entry(color : ColorData.UIColorFromRGB(0xE6E7EC), colorname : "#E6E7EC", content : "AlternativeBackground"),
        Entry(color : ColorData.UIColorFromRGB(0xB8E986), colorname : "#B8E986", content : "MyMessageBackground")
        ]
    
    
}
