//
//  CacheManager.swift
//  TestApp
//
//  Created by Krzysztof Lech on 26.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

class CacheManager {
    
    static let shared = CacheManager()
    
    enum CacheConfiguration {
        static let maxObjects = 5000
        static let maxSize = 150 * 150 * 5000
    }
    
    private static var cache: NSCache<NSString, AnyObject> = {
        let cache = NSCache<NSString, AnyObject>()
        cache.countLimit = CacheConfiguration.maxObjects
        cache.totalCostLimit = CacheConfiguration.maxSize
        return cache
    }()
    
    private init() { }
    
    func cache(object: AnyObject, forKey key: String) {
        CacheManager.cache.setObject(object, forKey: key as NSString)
    }
    
    func getFromCache(key: String) -> AnyObject? {
        return CacheManager.cache.object(forKey: key as NSString)
    }
}
