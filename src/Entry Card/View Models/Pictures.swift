//
//  Pictures.swift
//  Entry Card
//

import SwiftUI

fileprivate let maxPictures = 3

class Pictures: ObservableObject {
    @Published var collection: [Picture]

    init() {
        collection = Self.buildCollection()

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
        collection = Self.buildCollection()
    }

    static private func buildCollection() -> [Picture] {
        var pictures = StorageManager.loadPictures().enumerated().map { index, loadedPicture in
            Picture(index: index, loadedPicture: loadedPicture)
        }

        while pictures.count < maxPictures {
            let picture = Picture(index: pictures.count, loadedPicture: nil)
            pictures.append(picture)
        }

        return pictures
    }

    private var observer: NSObjectProtocol? = nil
}
