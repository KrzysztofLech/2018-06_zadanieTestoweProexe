//
//  MainViewController.swift
//  TestApp
//
//  Created by Krzysztof Lech on 26.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableContainer: UIView!
    @IBOutlet weak var detailContainer: UIView!
    
    var ipadTableVC: TableViewController?
    var ipadDetailVC: DetailViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshView),
                                               name: Notification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshView()
    }
    
    @objc private func refreshView() {
        let isPortrait = currentOrientationIsPortrait()
        
        if isPortrait {
            showOnlyTable()
        } else {
            showTableAndDetails()
        }
        ipadDetailVC?.hideBackButton(!isPortrait)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "iPad Table" {
            if let vc = segue.destination as? TableViewController {
                ipadTableVC = vc
                vc.parentVC = self
            }
        }
        
        if segue.identifier == "iPad Detail" {
            if let vc = segue.destination as? DetailViewController {
                ipadDetailVC = vc
                vc.parentVC = self
            }
        }
    }

    func showOnlyTable() {
        tableContainer.isHidden = false
        detailContainer.isHidden = true
    }
    
    func showOnlyDetails() {
        tableContainer.isHidden = true
        detailContainer.isHidden = false
    }
    
    func showTableAndDetails() {
        tableContainer.isHidden = false
        detailContainer.isHidden = false
    }
}
