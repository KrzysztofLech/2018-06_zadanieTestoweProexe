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
    
    //private static let baseUrl = "http://client.proexe.eu/json.json/"
    private static let baseUrl = "https://jsonplaceholder.typicode.com/photos/"
    
    
    static func getData(closure: @escaping (_ data: Data) -> ()) {
        guard let endPointUrl = URL(string: baseUrl) else {
            print("Error: Cannot create URL")
            return
        }
        
        Alamofire.request(endPointUrl)
            .responseData(completionHandler: { (response) in
                
                guard let data = response.data else {
                    print("Error: \(response.result.error)")
                    return
                }
                
                closure(data)
            })
    }
}
