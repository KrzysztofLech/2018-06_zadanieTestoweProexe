//
//  DataManager.swift
//  TestApp
//
//  Created by Krzysztof Lech on 26.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    var data: [Item] = {
        var array: [Item] = []
        array.reserveCapacity(100)
        return array
    }()
    
    private init() { }
    
    func getData(completion: @escaping (()->()) ) {
        removeAllData()
        
        print("Download data was started!")
        RequestManager.getData { (jsonData) in
            let decoder = JSONDecoder()
            do {
                let apiData = try decoder.decode(ApiData.self, from: jsonData)
                self.data = apiData.hits
                
                print("Downloading acomplished!")
                DispatchQueue.main.async {
                    completion()
                }
                
            } catch {
                print("Decode error: ", error)
            }
        }
    }
    
    func removeAllData() {
        data.removeAll(keepingCapacity: true)
    }
}
