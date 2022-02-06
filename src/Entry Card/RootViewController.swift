//
//  RootViewController.swift
//  Entry Card
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        checkLock = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if checkLock {
            checkLock = false

            if LockManager.shared.available && AppSettings.requireUnlock {
                showLockScreen()
            } else {
                showMainScreen()
            }
        }
    }

    func lockUI() {
        OperationQueue.main.addOperation { [weak self] in
            guard let self = self else { return }

            self.showLockScreen()
        }
    }

    func unlockUI() {
        OperationQueue.main.addOperation { [weak self] in
            guard let self = self else { return }

            self.showMainScreen()
        }
    }

    private func showLockScreen() {
        show(new: &lockVC, replacing: &mainVC)
    }

    private func showMainScreen() {
        show(new: &mainVC, replacing: &lockVC)
    }

    var checkLock = false
    var lockVC: LockViewController? = nil
    var mainVC: MainViewController? = nil

}
