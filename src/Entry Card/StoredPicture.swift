//
//  StoredPicture.swift
//  Entry Card
//

import Foundation

struct StoredPicture: Equatable {
    var filename: String
    var rotation: Int {
        didSet {
            rotation = rotation % 4
        }
    }

    init(filename: String, rotation: Int) {
        self.filename = filename
        self.rotation = rotation % 4
    }

}
