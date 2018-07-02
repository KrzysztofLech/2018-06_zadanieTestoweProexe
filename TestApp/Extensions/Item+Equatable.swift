//
//  Item+Equatable.swift
//  TestApp
//
//  Created by Krzysztof Lech on 02.07.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

extension Item: Equatable {
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name && lhs.imageUrl == rhs.imageUrl
    }
}
