//
//  TableViewController.swift
//  TestApp
//
//  Created by Krzysztof Lech on 27.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

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
        
        parentVC?.ipadDetailVC?.delegate = self
        
        showItemsNumber()
        showLastSelectedCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            segue.identifier == "Detail VC",
            let vc = segue.destination as? DetailViewController,
            let selectedItemIndex = sender as? Int {
            
            vc.delegate = self
            vc.currentPageIndex = selectedItemIndex
        }
    }
    
    @IBAction func shareButtonAction(_ sender: UIBarButtonItem) {
        let itemsToSend = DataManager.shared.data.filter { $0.selected }
        
        if itemsToSend.count > 0 {
            var textToSend = ""
            for item in itemsToSend {
                textToSend += item.name
                textToSend += "\n"
            }
            let vc = UIActivityViewController(activityItems: [textToSend], applicationActivities: [])
            vc.popoverPresentationController?.barButtonItem = sender
            present(vc, animated: true)
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
        selectCell(withIndex: indexPath.row, withScroll: false)
        
        if currentDeviceIsPad() {
            showDetails(withIndex: indexPath.row)
        } else {
            performSegue(withIdentifier: "Detail VC", sender: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        deleteItem(item: DataManager.shared.data[indexPath.row])
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
    
    fileprivate func showDetails(withIndex index: Int) {
        parentVC?.ipadDetailVC?.gotoPage(index)
        
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
    
    fileprivate func selectCell(withIndex index: Int, withScroll scroll: Bool) {
        let indexPath = IndexPath(row: index, section: 0)
        let scrollPosition: UITableViewScrollPosition = scroll ? .middle : .none
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: scrollPosition)
        
        setCellStyle(.selected, withIndexPath: indexPath)
        
        UserDefaultsManager.shared.selectedCellRowIndex = indexPath.row
    }
    
    fileprivate func showLastSelectedCell() {
        let index = UserDefaultsManager.shared.selectedCellRowIndex
        selectCell(withIndex: index, withScroll: true)
        
        if currentDeviceIsPad() && !currentOrientationIsPortrait() {
            showDetails(withIndex: index)
        }
    }
}

extension TableViewController: ItemProtocol {
    
    func deleteItem(item: Item) {
        for (index, arrayItem) in DataManager.shared.data.enumerated() {
            if arrayItem == item {
                DataManager.shared.data.remove(at: index)
                let indexPath = IndexPath(row: index, section: 0)
                tableView.deleteRows(at: [indexPath], with: .fade)
                showItemsNumber()
                
                // when deleted item was selected
                if index == UserDefaultsManager.shared.selectedCellRowIndex && currentDeviceIsPad() {
                    parentVC?.ipadDetailVC?.showNoItemInfo()
                }
            }
        }
    }
}

extension TableViewController: DetailsProtocol {
    
    func setupSelectedCell(index: Int) {
        selectCell(withIndex: index, withScroll: false)
        tableView.reloadData()
    }
}
