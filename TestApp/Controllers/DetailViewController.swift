//
//  DetailViewController.swift
//  TestApp
//
//  Created by Krzysztof Lech on 27.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemTitleLabel: UILabel!
    
    var parentVC: MainViewController?

    var item: Item! {
        didSet {
            if currentDeviceIsPad() {
                dataUpdate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideBackButton(currentDeviceIsPad())
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
    
    @IBAction private func backButtonAction() {
        if currentDeviceIsPad() {
            parentVC?.showOnlyTable()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func hideBackButton(_ action: Bool) {
        backButton.isHidden = action
    }
}
