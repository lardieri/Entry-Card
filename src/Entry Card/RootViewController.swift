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

    func lockImmediately() {
        guard self.lockVC == nil else { return }
        
        let lockVC = (storyboard!.instantiateViewController(withIdentifier: LockViewController.storyboardID) as! LockViewController)
        lockVC.alwaysShowTap = true

        addChild(lockVC)
        lockVC.view.frame = view.bounds
        self.view.addSubview(lockVC.view)
        lockVC.didMove(toParent: self)

        if let mainVC = self.mainVC {
            mainVC.willMove(toParent: nil)
            mainVC.view.removeFromSuperview()
            mainVC.removeFromParent()
        }

        self.mainVC = nil
        self.lockVC = lockVC
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
