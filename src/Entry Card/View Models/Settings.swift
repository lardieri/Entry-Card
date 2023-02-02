//
//  Settings.swift
//  Entry Card
//

import SwiftUI

class Settings: ObservableObject {
    @Published var useMaximumBrightness: Bool {
        didSet {
            AppSettings.useMaximumBrightness = useMaximumBrightness
        }
    }

    @Published var requireUnlock: Bool {
        didSet {
            AppSettings.requireUnlock = requireUnlock
        }
    }

    init() {
        useMaximumBrightness = AppSettings.useMaximumBrightness
        requireUnlock = AppSettings.requireUnlock

        observer = AppSettings.observeChanges { [weak self] notification in
            self?.handleSettingsChangeNotification(notification: notification)
        }
    }

    deinit {
        if let observer = observer {
            AppSettings.stopObservingChanges(observer)
        }
    }

    private func handleSettingsChangeNotification(notification: Notification) {
        let useMaximumBrightness = AppSettings.useMaximumBrightness
        if useMaximumBrightness != self.useMaximumBrightness {
            self.useMaximumBrightness = useMaximumBrightness
        }

        let requireUnlock = AppSettings.requireUnlock
        if requireUnlock != self.requireUnlock {
            self.requireUnlock = requireUnlock
        }
    }

    private var observer: NSObjectProtocol? = nil
}

