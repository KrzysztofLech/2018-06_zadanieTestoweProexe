//
//  DetailViewController.swift
//  TestApp
//
//  Created by Krzysztof Lech on 27.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

protocol DetailsProtocol {
    func setupSelectedCell(index: Int)
}

class DetailViewController: UIViewController {

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var presentedItemLabel: UILabel!
    @IBOutlet private var noDataView: UIView!
    
    var parentVC: MainViewController?
    var delegate: TableViewController?
    
    var currentPageIndex = 0
    private var nextPageIndex = 0
    private var itemsNumber = 0
    private var pageVC = UIPageViewController()

    
    // MARK: - VC Life Cycle Methods
    // ----------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsNumber = DataManager.shared.data.count
        
        hideBackButton(currentDeviceIsPad())
        initPageController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshCurrentPresentedItemLabel()
    }
    
    // MARK: - Back Button Methods
    // ----------------------------------------------------
    
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
    
    // MARK: - Other Methods
    // ----------------------------------------------------
    
    private func hideNoItemInfo() {
        noDataView.removeFromSuperview()
    }
    
    func showNoItemInfo() {
        view.addSubview(noDataView)
        noDataView.setConstraintsEqualTo(view: view)
    }
    
    func refreshCurrentPresentedItemLabel() {
        presentedItemLabel.text = String(format: "%i/%i", (currentPageIndex+1), itemsNumber)
        delegate?.setupSelectedCell(index: currentPageIndex)
    }
    
    // MARK: - Page Controller Methods
    // ----------------------------------------------------

    func initPageController() {
        guard itemsNumber > 0, let firstDetailsVC = viewControllerAtIndex(currentPageIndex) else { return }
        
        pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        pageVC.dataSource = self
        pageVC.delegate = self
        
        pageVC.setViewControllers(
            [firstDetailsVC],
            direction: .forward,
            animated: true,
            completion: nil)
        
        addChildViewController(pageVC)
        
        view.insertSubview(pageVC.view, belowSubview: backButton)
        pageVC.view.setConstraintsEqualTo(view: view)
        pageVC.didMove(toParentViewController: self)
    }
    
    private func viewControllerAtIndex(_ index: Int) -> DetailsContentViewController? {
        guard index < itemsNumber else { return nil }
        
        let pageContentVC = storyboard?.instantiateViewController(withIdentifier: "DetailsContentViewController") as! DetailsContentViewController
        pageContentVC.pageIndex = index
        pageContentVC.item = DataManager.shared.data[index]
        return pageContentVC
    }
    
    func gotoPage(_ index: Int) {
        hideNoItemInfo()
        
        currentPageIndex = index
        if let vc = viewControllerAtIndex(index) {
            pageVC.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
            refreshCurrentPresentedItemLabel()
        }
    }
}

extension DetailViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    // MARK: DataSource methods
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let vc = viewController as? DetailsContentViewController,
            let index = vc.pageIndex,
            index > 0
            else { return nil }
        
        return viewControllerAtIndex(index-1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let vc = viewController as? DetailsContentViewController,
            let index = vc.pageIndex,
            index < (itemsNumber - 1)
        else { return nil }

        return viewControllerAtIndex(index+1)
    }
    
    // MARK: Delegate methods

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let pendingVC = pendingViewControllers[0] as? DetailsContentViewController, let index = pendingVC.pageIndex {
            nextPageIndex = index
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if nextPageIndex > currentPageIndex { currentPageIndex += 1 }
            else if nextPageIndex < currentPageIndex { currentPageIndex -= 1 }
            refreshCurrentPresentedItemLabel()
        }
    }
}
