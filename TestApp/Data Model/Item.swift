//
//  Item.swift
//  TestApp
//
//  Created by Krzysztof Lech on 26.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

class ApiData: Codable {
    
    var total:      Int = 0
    var totalHits:  Int = 0
    var hits:       [Item] = []
}

class Item: Codable {
    
    var name:       String = ""
    var previewUrl: String = ""
    var imageUrl:   String = ""
    var selected:   Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name       = "user"
        case previewUrl = "previewURL"
        case imageUrl   = "largeImageURL"
    }
}
