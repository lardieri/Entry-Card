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

    func replace(with url: URL) {
        let _ = StorageManager.addPicture(fromURL: url, atPosition: index)
    }

    func replace(with image: UIImage) {
        let _ = StorageManager.addPicture(fromImage: image, atPosition: index)
    }

    private var loadedPicture: LoadedPicture? {
        didSet {
            image = loadedPicture?.rotatedImage()
        }
    }

    private let index: Int
}
