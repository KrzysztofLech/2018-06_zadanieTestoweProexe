//
//  RequestManager.swift
//  TestApp
//
//  Created by Krzysztof Lech on 26.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation
import Alamofire

struct RequestManager {
    
    private static let baseUrl = "https://pixabay.com/api/"
    private static let parameters: [String : Any] = [
        "key" : "9485555-ef481e6738821b2b89a42b79c",
        "image_type" : "photo",
        "per_page" : 100,
        "q" : "greece+sea"
    ]

    
    static func getData(closure: @escaping (_ data: Data) -> ()) {
        guard let endPointUrl = URL(string: baseUrl) else {
            print("Error: Cannot create URL")
            return
        }
        Alamofire.request(endPointUrl, method: .get, parameters: parameters)
            .responseData(completionHandler: { (response) in
                
                guard let data = response.data else {
                    print("Error: \(response.result.error)")
                    return
                }
                
                closure(data)
            })
    }
}
