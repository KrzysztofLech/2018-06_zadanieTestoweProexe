//
//  Item.swift
//  TestApp
//
//  Created by Krzysztof Lech on 26.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

class Item: Codable {
    
    var name:     String = ""
    var imageUrl: String = ""
    var selected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name     = "title"
        case imageUrl = "url"
    }
}
