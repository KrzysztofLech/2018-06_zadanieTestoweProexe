//
//  DataTableViewCell.swift
//  TestApp
//
//  Created by Krzysztof Lech on 27.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

enum CellStyle {
    case none, selected, highlighted
}

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!

    var imageUrl = ""
    var cellState: CellStyle = .none {
        didSet {
            switch cellState {
            case .none: deselectedAppearance()
            case .selected: selectedAppearance()
            case .highlighted: highlightedAppearance()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetCell()
    }
    
    private func resetCell() {
        itemImageView.image = nil
        itemTitleLabel.text = nil
        imageUrl = ""
        activityIndicator.startAnimating()
        cellState = .none
    }
    
    func update(withItem item: Item) {
        itemTitleLabel.text = item.name
        imageUrl = item.imageUrl
    }
    
    // MARK: - Cell appearance styles

    private func deselectedAppearance() {
        self.backgroundColor = .white
        itemTitleLabel.textColor = .black
    }

    private func selectedAppearance() {
        self.backgroundColor = .red
        itemTitleLabel.textColor = .white
    }
    
    private func highlightedAppearance() {
        self.backgroundColor = .blue
        itemTitleLabel.textColor = .white
    }
}
