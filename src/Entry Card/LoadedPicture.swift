//
//  LoadedPicture.swift
//  Entry Card
//

import UIKit

struct LoadedPicture {

    let originalImage: UIImage
    let filename: String
    var rotation: Int {
        didSet {
            rotation = rotation % 4
        }
    }

    func rotatedImage() -> UIImage {
        guard let cgImage = originalImage.cgImage else { return originalImage }
        let scale = originalImage.scale
        var orientation = originalImage.imageOrientation

        for _ in 0 ..< rotation {
            orientation = orientation.rotated()
        }

        return UIImage(cgImage: cgImage, scale: scale, orientation: orientation)
    }

}


extension LoadedPicture: Equatable {

    static func == (lhs: LoadedPicture, rhs: LoadedPicture) -> Bool {
        return lhs.filename == rhs.filename && lhs.rotation == rhs.rotation
    }

}


fileprivate extension UIImage.Orientation {

    func rotated() -> UIImage.Orientation {
        switch self {
            case .up:               return .right
            case .right:            return .down
            case .down:             return .left
            case .left:             return .up

            case .upMirrored:       return .rightMirrored
            case .rightMirrored:    return .downMirrored
            case .downMirrored:     return .leftMirrored
            case .leftMirrored:     return .upMirrored

            @unknown default:       return self
        }
    }

}
