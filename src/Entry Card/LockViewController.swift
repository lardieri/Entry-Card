//
//  LockViewController.swift
//  Entry Card
//

import UIKit

class LockViewController: UIViewController, HasStoryboardID {

    static var storyboardID: String { Storyboard.lockScreenViewController }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if !LockManager.shared.available {
            NotificationCenter.default.post(name: .unlockUI, object: self)
        }

        super.viewWillAppear(animated)
    }

    @IBAction func lockScreenTapped(sender: UITapGestureRecognizer) {
        LockManager.shared.requestUnlock { result in
            switch result {
                case .succeeded:
                    NotificationCenter.default.post(name: .unlockUI, object: self)

                case .failed:
                    return
            }
        }
    }

}
