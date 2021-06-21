//
//  AppSettings.swift
//  Entry Card
//

import Foundation

class AppSettings {

    private enum Key {
        static let pictureFiles = "pictureFiles"
        static let useMaximumBrightness = "useMaximumBrightness"
    }

    static func establishDefaults() {
        let defaults = [
            Key.useMaximumBrightness : false
        ]

        UserDefaults.standard.register(defaults: defaults)
    }

    static func observeChanges(block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: UserDefaults.standard, queue: .main, using: block)
    }

    static func stopObservingChanges(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }

    static var pictureFiles: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: Key.pictureFiles) ?? [String]()
        }

        set {
            if newValue != pictureFiles {
                UserDefaults.standard.set(newValue, forKey: Key.pictureFiles)
            }
        }
    }

    static var useMaximumBrightness: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Key.useMaximumBrightness)
        }

        set {
            if newValue != useMaximumBrightness {
                UserDefaults.standard.set(newValue, forKey: Key.useMaximumBrightness)
            }
        }
    }

}
