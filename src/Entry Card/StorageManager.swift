//
//  StorageManager.swift
//  Entry Card
//

import UIKit
import PDFKit

class StorageManager {

    static let maxPictures = 9
    private static let jpegQuality: CGFloat = 0.8
    private static let jpegExtension = "jpg"

    static func loadPictures() -> [LoadedPicture?] {
        var loadedPictures = [LoadedPicture?]()
        guard let directory = storageDirectory else { return loadedPictures }

        for (index, storedPicture) in AppSettings.storedPictures.enumerated() {
            guard index < maxPictures else { break }

            if !storedPicture.filename.isEmpty {
                let url = directory.appendingPathComponent(storedPicture.filename)
                if let image = UIImage.fromURL(url) {
                    loadedPictures.append(LoadedPicture(originalImage: image, filename: storedPicture.filename, rotation: storedPicture.rotation))
                    continue
                } else {
                    OperationQueue.current!.addOperation {
                        removePicture(fromPosition: index)
                    }
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

    static func addPicture(fromURL sourceURL: URL, atPosition index: Int) -> Bool {
        guard let destinationURL = nextFileURL(withExtension: sourceURL.pathExtension) else { return false }

        guard sourceURL.startAccessingSecurityScopedResource() else { return false }
        defer { sourceURL.stopAccessingSecurityScopedResource() }

        var coordinatorError: NSError? = nil
        var copySucceeded: Bool = false
        NSFileCoordinator().coordinate(readingItemAt: sourceURL, options: [], writingItemAt: destinationURL, options: [.forReplacing], error: &coordinatorError) { sourceURL, destinationURL in
            do {
                try fileManager.copyItem(at: sourceURL, to: destinationURL)
                copySucceeded = true
            } catch {
                print("File copy error: \(error)")
            }
        }

        guard copySucceeded else { return false }

        addSavedFilename(destinationURL.lastPathComponent, atPosition: index)

        return true
    }

    static func removePicture(fromPosition index: Int) {
        guard index < AppSettings.storedPictures.count else { return }

        let filename = AppSettings.storedPictures[index].filename
        guard !filename.isEmpty else { return }

        guard let directory = storageDirectory else { return }

        let fullPath = directory.appendingPathComponent(filename)

        do {
            print("Removing file \(fullPath.path)")
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
        let newStoredPicture = StoredPicture(filename: filename, rotation: 0)

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


fileprivate extension StoredPicture {

    private static let placeholderFilename = String()
    static let placeholder = StoredPicture(filename: placeholderFilename, rotation: 0)

}


extension UIImage {

    static func fromURL(_ url: URL) -> UIImage? {
        if url.pathExtension == "pdf" {
            return Self.fromPDF(url)
        } else {
            return Self.init(contentsOfFile: url.path)
        }
    }

    private static func fromPDF(_ url: URL) -> UIImage? {
        guard let document = PDFDocument(url: url) else { return nil }
        guard let page = document.page(at: 0) else { return nil }

        let pageRect = page.bounds(for: .cropBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let image = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            page.draw(with: .cropBox, to: ctx.cgContext)
        }

        return image
    }

}
