//
//  TableViewController.swift
//  TestApp
//
//  Created by Krzysztof Lech on 27.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit
import MessageUI

class TableViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var parentVC: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showItemsNumber()
        showLastSelectedCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail VC" {
            if let vc = segue.destination as? DetailViewController {
                if let item = sender as? Item {
                    vc.item = item
                }
            }
        }
    }
    
    @IBAction func shareButtonAction(_ sender: UIBarButtonItem) {
        if MFMailComposeViewController.canSendMail() {
            
            let itemsToSend = DataManager.shared.data.filter { $0.selected }
            if itemsToSend.count > 0 {
                var textToSend = ""
                for item in itemsToSend {
                    textToSend += item.name
                    textToSend += "\n"
                }
                
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setSubject("Message!")
                mail.setMessageBody(textToSend, isHTML: false)
                
                present(mail, animated: true)
            }
        }
    }
    
    private func showItemsNumber() {
        navigationBar.topItem?.title = String(format: "Downloaded %i items", DataManager.shared.data.count)
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataCount = DataManager.shared.data.count
        return dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DataTableViewCell {
            
            let item = DataManager.shared.data[indexPath.row]
            cell.update(withItem: item)
            ImageManager.getImage(withUrl: item.imageUrl) { image in
                if cell.imageUrl == item.imageUrl {
                    cell.activityIndicator.stopAnimating()
                    cell.itemImageView.image = image
                }
            }
            if UserDefaultsManager.shared.selectedCellRowIndex == indexPath.row {
                cell.cellState = .selected
            }
            
            cell.delegate = self
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCell(withIndexPath: indexPath, withScroll: false)
        
        let selectedItem = DataManager.shared.data[indexPath.row]
        if currentDeviceIsPad() {
            showDetails(withItem: selectedItem)
        } else {
            performSegue(withIdentifier: "Detail VC", sender: selectedItem)
        }
    }
    
    // MARK: - Appearance Methods
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        deselectPreviousSelectedCell()
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        setCellStyle(.highlighted, withIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        setCellStyle(.none, withIndexPath: indexPath)
    }
    
    private func setCellStyle(_ cellStyle: CellStyle, withIndexPath indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? DataTableViewCell
        cell?.cellState = cellStyle
    }
    
    // MARK: - Other TableView Methods
    
    fileprivate func showDetails(withItem item: Item) {
        parentVC?.ipadDetailVC?.item = item
        if currentOrientationIsPortrait() {
            parentVC?.showOnlyDetails()
        }
    }
    
    fileprivate func deselectPreviousSelectedCell() {
        if let previousSelectedCellIndex = tableView.indexPathForSelectedRow {
            setCellStyle(.none, withIndexPath: previousSelectedCellIndex)
            tableView.deselectRow(at: previousSelectedCellIndex, animated: true)
        }
    }
    
    fileprivate func selectCell(withIndexPath indexPath: IndexPath, withScroll scroll: Bool) {
        let scrollPosition: UITableViewScrollPosition = scroll ? .middle : .none
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: scrollPosition)
        
        setCellStyle(.selected, withIndexPath: indexPath)
        
        UserDefaultsManager.shared.selectedCellRowIndex = indexPath.row
    }
    
    fileprivate func showLastSelectedCell() {
        let indexPath = IndexPath(row: UserDefaultsManager.shared.selectedCellRowIndex, section: 0)
        selectCell(withIndexPath: indexPath, withScroll: true)
        
        if currentDeviceIsPad() {
            let selectedItem = DataManager.shared.data[indexPath.row]
            showDetails(withItem: selectedItem)
        }
    }
}

extension TableViewController: ItemProtocol {
    
    func deleteItem(item: Item) {
        for (index, arrayItem) in DataManager.shared.data.enumerated() {
            if arrayItem.imageUrl == item.imageUrl {
                DataManager.shared.data.remove(at: index)
                let indexPath = IndexPath(row: index, section: 0)
                tableView.deleteRows(at: [indexPath], with: .fade)
                showItemsNumber()
            }
        }
        
        // when deleted item was selected
        if let detailVC = parentVC?.ipadDetailVC, let detailItem = detailVC.item, item == detailItem {
            detailVC.noItemInfo()
        }
    }
}

extension TableViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
