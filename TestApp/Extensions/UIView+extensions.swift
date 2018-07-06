//
//  UIView+extensions.swift
//  TestApp
//
//  Created by Krzysztof Lech on 06.07.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

extension UIView {
    
    func setConstraintsEqualTo(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
}
