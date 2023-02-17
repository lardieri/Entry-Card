//
//  Settings.swift
//  Entry Card
//

import SwiftUI

class Settings: ObservableObject {
    struct Icon: Identifiable {
        let alternateIconName: String?
        let displayImageName: String

        var id: String? { alternateIconName }
    }

    static let availableIcons: [Icon] = [
        Icon(alternateIconName: nil,                        displayImageName: "Icon - default"),
        Icon(alternateIconName: "AppIcon-VelvetRopeGray",   displayImageName: "Icon - gray"),
        Icon(alternateIconName: "AppIcon-VaxCard",          displayImageName: "Icon - vax"),
        Icon(alternateIconName: "AppIcon-VIP",              displayImageName: "Icon - vip")
    ]

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

    @Published var alternateIconName: String? {
        didSet {
            if alternateIconName != UIApplication.shared.alternateIconName {
                UIApplication.shared.setAlternateIconName(alternateIconName)
            }
        }
    }

    init() {
        useMaximumBrightness = AppSettings.useMaximumBrightness
        requireUnlock = AppSettings.requireUnlock
        alternateIconName = UIApplication.shared.alternateIconName

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
        OperationQueue.main.addOperation {
            let useMaximumBrightness = AppSettings.useMaximumBrightness
            if useMaximumBrightness != self.useMaximumBrightness {
                self.useMaximumBrightness = useMaximumBrightness
            }

            let requireUnlock = AppSettings.requireUnlock
            if requireUnlock != self.requireUnlock {
                self.requireUnlock = requireUnlock
            }
        }
    }

    private var observer: NSObjectProtocol? = nil
}

