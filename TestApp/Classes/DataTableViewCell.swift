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

protocol ItemProtocol {
    func deleteItem(item: Item)
}

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemSwitch: UISwitch!
    
    var item: Item?
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
    
    var delegate: ItemProtocol?
    
    
    // MARK: - Methods
    // ----------------------------------------------------
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetCell()
    }
    
    private func resetCell() {
        item = nil
        itemImageView.image = nil
        itemTitleLabel.text = nil
        imageUrl = ""
        activityIndicator.startAnimating()
        cellState = .none
        itemSwitch.setOn(false, animated: false)
    }
    
    func update(withItem item: Item) {
        self.item = item
        itemTitleLabel.text = item.name
        imageUrl = item.imageUrl
        itemSwitch.setOn(item.selected, animated: false)
    }
    
    
    // MARK: - Back Button Methods
    // ----------------------------------------------------
    
    @IBAction func switchValueChangedAction() {
        guard let item = item else { return }
        
        item.selected = itemSwitch.isOn
    }
    
    @IBAction func deleteButtonAction() {
        guard let item = item else { return }
        
        delegate?.deleteItem(item: item)
    }
    
    
    // MARK: - Cell appearance styles
    // ----------------------------------------------------
    
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
