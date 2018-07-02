//
//  Helper.swift
//  TestApp
//
//  Created by Krzysztof Lech on 26.06.2018.
//  Copyright © 2018 Krzysztof Lech. All rights reserved.
//

import UIKit

// no buttons allert
func alertWithNoButton(title: String?, message: String?) {
    guard let controller = UIApplication.getPresentedViewController() else { return }
    
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.present(ac, animated: true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            controller.dismiss(animated: true, completion: nil)
        })
    }
}

// one button  alert
func alertWithOneButton(title: String?, message: String?, buttonTitle: String, buttonStyle: UIAlertActionStyle, completion: @escaping (UIAlertAction)->()) {
    guard let controller = UIApplication.getPresentedViewController() else { return }
    
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let buttonOneAction = UIAlertAction(title: buttonTitle, style: buttonStyle, handler: completion)
    ac.addAction(buttonOneAction)
    
    controller.present(ac, animated: true)
}

// one button & cancel alert
func alertWithOneButtonAndCancel(title: String?, message: String?, buttonTitle: String, buttonStyle: UIAlertActionStyle, completion: @escaping (UIAlertAction)->()) {
    guard let controller = UIApplication.getPresentedViewController() else { return }
    
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let buttonOneAction = UIAlertAction(title: buttonTitle, style: buttonStyle, handler: completion)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    ac.addAction(buttonOneAction)
    ac.addAction(cancelAction)
    controller.present(ac, animated: true)
}

func currentDevice() -> UIUserInterfaceIdiom {
    return UIDevice.current.userInterfaceIdiom
}

func currentDeviceIsPad() -> Bool {
    return currentDevice() == .pad
}

func currentOrientation() -> UIInterfaceOrientation {
    return UIApplication.shared.statusBarOrientation
}

func currentOrientationIsPortrait() -> Bool {
    let orientation = currentOrientation()
    if orientation == .portrait || orientation == .portraitUpsideDown {
        return true
    }
    return false
}
