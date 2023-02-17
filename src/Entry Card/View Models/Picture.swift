//
//  Picture.swift
//  Entry Card
//

import SwiftUI

class Picture: ObservableObject, Identifiable {
    var id: Int { index }

    @Published private(set) var image: UIImage?

    init(index: Int, loadedPicture: LoadedPicture?) {
        self.index = index
        self.loadedPicture = loadedPicture
        self.image = loadedPicture?.rotatedImage()
    }

    func rotate() {
        guard loadedPicture != nil else { return }
        loadedPicture!.rotation += 1
        AppSettings.storedPictures[index].rotation = loadedPicture!.rotation
    }

    func clear() {
        guard loadedPicture != nil else { return }
        loadedPicture = nil
        StorageManager.removePicture(fromPosition: index)
    }

    private var loadedPicture: LoadedPicture? {
        didSet {
            image = loadedPicture?.rotatedImage()
        }
    }

    private let index: Int
}
