//
//  ImageManager.swift
//  TestApp
//
//  Created by Krzysztof Lech on 26.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

struct ImageManager {
    
    static func getImage(withUrl urlString: String, closure: @escaping (_ image: UIImage) -> ()) {
        if let image = CacheManager.shared.getFromCache(key: urlString) as? UIImage {
            closure(image)
        } else {
            downloadImage(withUrl: urlString, closure: closure)
        }
    }
    
    static func downloadImage(withUrl urlString: String, closure: @escaping (_ image: UIImage) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) { (url, response, error) in
            if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                CacheManager.shared.cache(object: image, forKey: urlString)
                DispatchQueue.main.async {
                    closure(image)
                }
            }
        }
        downloadTask.resume()
    }
}
