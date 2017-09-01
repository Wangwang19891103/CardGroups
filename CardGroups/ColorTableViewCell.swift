//
//  ColorTableViewCell.swift
//  CardGroups
//
//  Created by Wang on 7/13/16.
//  Copyright © 2016 Wang. All rights reserved.
//

import UIKit

class ColorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var colorname: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
