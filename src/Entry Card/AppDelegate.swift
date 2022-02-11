//
//  AppDelegate.swift
//  Entry Card
//

import UIKit
import BrightnessToggle

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppSettings.registerDefaults()

        if lockObserver == nil {
            lockObserver = NotificationCenter.default.addObserver(forName: .lockUI, object: nil, queue: .main, using: lockUI(_:))
        }

        if unlockObserver == nil {
            unlockObserver = NotificationCenter.default.addObserver(forName: .unlockUI, object: nil, queue: .main, using: unlockUI(_:))
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        BrightnessToggle.applicationWillResignActive()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        BrightnessToggle.applicationWillEnterForeground()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if LockManager.shared.available && AppSettings.requireUnlock {
            if let rootVC = window?.rootViewController as? RootViewController {
                rootVC.lockImmediately()
            }
        }
    }

    private func lockUI(_: Notification) {
        if let rootVC = window?.rootViewController as? RootViewController {
            rootVC.lockUI()
        }
    }

    private func unlockUI(_: Notification) {
        if let rootVC = window?.rootViewController as? RootViewController {
            rootVC.unlockUI()
        }
    }

    var lockObserver: NSObjectProtocol? = nil
    var unlockObserver: NSObjectProtocol? = nil

}


extension NSNotification.Name {

    static let lockUI = NSNotification.Name("Entry Card - lock UI")
    static let unlockUI = NSNotification.Name("Entry Card - unlock UI")

}
