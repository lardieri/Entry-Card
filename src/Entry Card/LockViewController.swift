//
//  LockViewController.swift
//  Entry Card
//

import UIKit

class LockViewController: UIViewController, HasStoryboardID {

    static var storyboardID: String { Storyboard.lockScreenViewController }

    private let fadeTime = 0.5

    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var tapGesture: UITapGestureRecognizer!

    var alwaysShowTap = false

    override func viewWillAppear(_ animated: Bool) {
        if !LockManager.shared.available {
            unlock()
        } else if LockManager.shared.faceAvailable || alwaysShowTap {
            showTap()
        } else {
            hideTap()
            request()
        }

        super.viewWillAppear(animated)
    }

    @IBAction func lockScreenTapped(sender: UITapGestureRecognizer) {
        request()
    }

    private func unlock() {
        NotificationCenter.default.post(name: .unlockUI, object: self)
    }

    private func request() {
        OperationQueue.main.addOperation {
            LockManager.shared.requestUnlock { [weak self] result in
                guard let self = self else { return }

                switch result {
                    case .succeeded:
                        self.unlock()

                    case .failed:
                        self.showTap()
                        return
                }
            }
        }
    }

    private func hideTap() {
        tapGesture.isEnabled = false
        UIView.animate(withDuration: fadeTime) { [weak self] in
            self?.tapLabel.alpha = 0.0
        }
    }

    private func showTap() {
        tapGesture.isEnabled = true
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.tapLabel.alpha = 1.0
        }
    }
}
