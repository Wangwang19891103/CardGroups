//
//  PlacesTableViewCell.swift
//  CardGroups
//
//  Created by Wang on 7/10/16.
//  Copyright © 2016 Wang. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var headLbl: UILabel!
    @IBOutlet weak var groupLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var starImg: UIImageView!
    @IBOutlet weak var passButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
