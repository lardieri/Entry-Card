//
//  AppSettings.swift
//  Entry Card
//

import Foundation

class AppSettings {

    private enum Key {
        static let storedPictures = "pictures"
        static let pictureFiles = "pictureFiles" // legacy
        static let useMaximumBrightness = "useMaximumBrightness"
    }

    static func registerDefaults() {
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

    static var storedPictures: [StoredPicture] {
        get {
            return UserDefaults.standard.array(forKey: Key.storedPictures)?
                .compactMap( { $0 as? StoredPicture.DictionaryRepresentation } )
                .compactMap( { StoredPicture(fromDictionary: $0) } )
            ??
            UserDefaults.standard.stringArray(forKey: Key.pictureFiles)?
                .map( { StoredPicture(filename: $0, rotation: 0) } )
            ?? []
        }

        set {
            UserDefaults.standard.removeObject(forKey: Key.pictureFiles)
            if newValue != storedPictures {
                UserDefaults.standard.set(newValue.map( { $0.toDictionary() } ), forKey: Key.storedPictures)
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


fileprivate extension StoredPicture {

    private enum Key {
        static let filename = "filename"
        static let rotation = "rotation"
    }

    typealias DictionaryRepresentation = [ String : Any ]

    init?(fromDictionary dictionary: DictionaryRepresentation) {
        if let filename = dictionary[Key.filename] as? String,
           let rotation = dictionary[Key.rotation] as? Int {
            self.filename = filename
            self.rotation = rotation
        } else {
            return nil
        }
    }

    func toDictionary() -> DictionaryRepresentation {
        var dictionary = DictionaryRepresentation()

        dictionary[Key.filename] = self.filename
        dictionary[Key.rotation] = self.rotation
        
        return dictionary
    }

}
