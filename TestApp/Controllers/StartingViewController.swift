//
//  StartingViewController.swift
//  TestApp
//
//  Created by Krzysztof Lech on 26.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class StartingViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getData()
    }
    
    private func getData() {
        if ReachabilityManager.shared.isReachable() {
            DataManager.shared.getData {
                self.showMainVC()
            }
        } else {
            alertWithOneButton(title: "No Internet!",
                               message: nil,
                               buttonTitle: "Try again", buttonStyle: .default) { _ in
                                self.getData()
            }
        }
    }
    
    private func showMainVC() {
        switch currentDevice() {
        case .phone:
            performSegue(withIdentifier: "Table VC", sender: nil)
            print("iPhone")
            
        case .pad:
            performSegue(withIdentifier: "iPad VC", sender: nil)
            print("iPad")
            
        default: break
        }
    }
}
