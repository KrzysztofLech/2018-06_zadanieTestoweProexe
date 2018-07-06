//
//  DetailsContentViewController.swift
//  TestApp
//
//  Created by Krzysztof Lech on 03.07.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class DetailsContentViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemTitleLabel: UILabel!
    
    var pageIndex: Int?
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataUpdate()
    }
    
    private func dataUpdate() {
        if let item = item {
            itemTitleLabel.text = item.name
            itemImageView.image = nil
            
            activityIndicator.startAnimating()
            showImage()
        }
    }
    
    private func showImage() {
        ImageManager.getImage(withUrl: item.imageUrl) { [weak self] image in
            self?.activityIndicator.stopAnimating()
            self?.itemImageView.image = image
        }
    }
}
