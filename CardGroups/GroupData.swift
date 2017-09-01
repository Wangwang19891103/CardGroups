//
//  GroupData.swift
//  CardGroups
//
//  Created by Wang on 7/12/16.
//  Copyright © 2016 Wang. All rights reserved.
//

import Foundation

class GroupData {
    class Entry {
        let rate : Bool
        let groupname : String
        let heading : String
        let content : String
        init(rate : Bool, gname : String, heading : String, content : String) {
            self.rate = rate
            self.heading = heading
            self.groupname = gname
            self.content = content
        }
    }
    
    let places = [
        Entry(rate : false, gname: "Kids, Education", heading: "Edward Vince" , content: "Finnegan’s surfing life is undiminished. Frantically juggling work and family, he chases his enchantment through Long Island ice storms and obscure corners of Madagascar. From the Hardcover edition."),
        Entry(rate : false, gname: "Work", heading: "Edward Vince" , content: "Finnegan’s surfing life is undiminished. Frantically juggling work and family, he chases his enchantment through Long Island ice storms and obscure corners of Madagascar. From the Hardcover edition."),
        Entry(rate : false, gname: "Sales", heading: "Edward Vince" , content: "Finnegan’s surfing life is undiminished. Frantically juggling work and family, he chases his enchantment through Long Island ice storms and obscure corners of Madagascar. From the Hardcover edition."),
    ]
    
}
