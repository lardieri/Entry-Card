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
        AppSettings.establishDefaults()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        BrightnessToggle.applicationWillResignActive()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        BrightnessToggle.applicationWillEnterForeground()
    }

}

