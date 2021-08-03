//
//  UIBarButtonItem visibility.swift
//  Entry Card
//
//  Credit:
//      Mike Woelmer
//      Atomic Object LLC
//      https://spin.atomicobject.com/2018/03/15/extend-uibarbuttonitem/
//

import UIKit

public extension UIBarButtonItem {

    var isHidden: Bool {
        get {
            return tintColor == UIColor.clear
        }

        set(hide) {
            if hide {
                isEnabled = false
                tintColor = UIColor.clear
            } else {
                isEnabled = true
                tintColor = nil // This sets the tintColor back to the default. If you have a custom color, use that instead.
            }
        }
    }

}
