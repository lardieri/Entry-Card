//
//  Picture.swift
//  Entry Card
//

import SwiftUI

class Picture: ObservableObject, Identifiable {
    let id: Int

    @Published private(set) var image: UIImage?

    init(index: Int, loadedPicture: LoadedPicture?) {
        self.id = index
        self.loadedPicture = loadedPicture
        self.image = loadedPicture?.rotatedImage()
    }

    func rotate() {
        guard loadedPicture != nil else { return }
        loadedPicture!.rotation += 1
        AppSettings.storedPictures[id].rotation = loadedPicture!.rotation
    }

    func clear() {
        guard loadedPicture != nil else { return }
        loadedPicture = nil
        StorageManager.removePicture(fromPosition: id)
    }

    func replace() {

    }

    private var loadedPicture: LoadedPicture? {
        didSet {
            image = loadedPicture?.rotatedImage()
        }
    }
}
