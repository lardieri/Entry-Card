//
//  StorageManager.swift
//  Entry Card
//

import UIKit

class StorageManager {

    private static let maxPictures = 3
    private static let jpegQuality: CGFloat = 0.8
    private static let jpegExtension = "jpg"

    typealias LoadedPicture = (filename: String, image: UIImage)

    static func loadPictures() -> [LoadedPicture?] {
        var loadedPictures = [LoadedPicture?]()
        guard let directory = storageDirectory else { return loadedPictures }

        let pictureFiles = AppSettings.storedPictures.map { $0.filename }
        for (index, filename) in pictureFiles.enumerated() {
            guard index < maxPictures else { break }

            if !filename.isEmpty {
                let fullPath = directory.appendingPathComponent(filename)
                if let image = UIImage(contentsOfFile: fullPath.path) {
                    loadedPictures.append((filename, image))
                    continue
                } else {
                    removePicture(fromPosition: index)
                }
            }

            loadedPictures.append(nil)
        }

        return loadedPictures
    }

    static func addPicture(fromImage image: UIImage, atPosition index: Int) -> Bool {
        var success = false

        if let fileURL = nextFileURL(withExtension: jpegExtension),
           let jpegData = image.jpegData(compressionQuality: jpegQuality) {
            do {
                try jpegData.write(to: fileURL)
                addSavedFilename(fileURL.lastPathComponent, atPosition: index)
                success = true
            } catch {

                // TEST TEST TEST
                print ("File error!")
                // TEST TEST TEST

            }
        }

        return success
    }

    static func addPicture(fromURL sourceUrl: URL, atPosition index: Int) -> Bool {
        var success = false

        if let fileURL = nextFileURL(withExtension: sourceUrl.pathExtension) {
            do {
                try fileManager.copyItem(at: sourceUrl, to: fileURL)
                addSavedFilename(fileURL.lastPathComponent, atPosition: index)
                success = true
            } catch {

                // TEST TEST TEST
                print ("File error!")
                // TEST TEST TEST

            }
        }

        return success
    }

    static func removePicture(fromPosition index: Int) {
        guard index < AppSettings.storedPictures.count else { return }

        let filename = AppSettings.storedPictures[index].filename
        guard !filename.isEmpty else { return }

        guard let directory = storageDirectory else { return }

        let fullPath = directory.appendingPathComponent(filename)

        do {
            try fileManager.removeItem(at: fullPath)
        } catch {

            // TEST TEST TEST
            print ("File error!")
            // TEST TEST TEST

        }

        removeSavedFilename(fromPosition: index)
    }

    private static func addSavedFilename(_ filename: String, atPosition index: Int) {
        guard index < maxPictures else { return }

        var storedPictures = AppSettings.storedPictures
        let newStoredPicture = AppSettings.StoredPicture(filename: filename, rotation: 0)

        if storedPictures.count > index {
            storedPictures[index] = newStoredPicture
        } else {
            while storedPictures.count < index {
                storedPictures.append(.placeholder)
            }

            storedPictures.append(newStoredPicture)
        }

        AppSettings.storedPictures = storedPictures
    }

    private static func removeSavedFilename(fromPosition index: Int) {
        guard index < AppSettings.storedPictures.count else { return }

        AppSettings.storedPictures[index] = .placeholder
    }

    private static func nextFileURL(withExtension pathExtension: String) -> URL? {
        serialNumber += 1
        let baseFileName = "\(serialNumber)"
        return storageDirectory?.appendingPathComponent(baseFileName).appendingPathExtension(pathExtension)
    }

    static func cleanStorageDirectory() {
        guard let storageDirectory = storageDirectory else { return }

        if let allFiles = try? fileManager.contentsOfDirectory(at: storageDirectory, includingPropertiesForKeys: []) {
            let pictureFiles = AppSettings.storedPictures.map( { $0.filename } )
            let extraneousFiles = allFiles.drop { pictureFiles.contains($0.lastPathComponent) }
            for file in extraneousFiles {
                try? fileManager.removeItem(at: file)
            }
        }

        if let tmpFiles = try? fileManager.contentsOfDirectory(at: fileManager.temporaryDirectory, includingPropertiesForKeys: []) {
            for file in tmpFiles {
                try? fileManager.removeItem(at: file)
            }
        }
    }

    private static let storageDirectory: URL? =
        try? fileManager.url(for: .applicationSupportDirectory,
                             in: .userDomainMask,
                             appropriateFor: nil,
                             create: true)

    private static let fileManager = FileManager.default

    private static var serialNumber: UInt = {
        guard let storageDirectory = storageDirectory else { return 0 }

        let strippedFilenames = try? fileManager.contentsOfDirectory(at: storageDirectory, includingPropertiesForKeys: []).map { $0.deletingPathExtension().lastPathComponent }
        return strippedFilenames?.compactMap { UInt($0) }.max() ?? 0
    }()

}
