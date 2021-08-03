//
//  RotateImage.swift
//  Entry Card
//

import UIKit

func rotate(originalImage: UIImage) -> UIImage {
    let originalSize = originalImage.size
    let rotatedSize = CGSize.init(width: floor(originalSize.height), height: floor(originalSize.width))

    UIGraphicsBeginImageContext(rotatedSize)

    guard let context = UIGraphicsGetCurrentContext() else { return originalImage }

    let midpoint = CGPoint(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
    context.translateBy(x: midpoint.x, y: midpoint.y)
    context.rotate(by: .pi / 2.0)
    originalImage.draw(in: CGRect(x: -midpoint.y, y: -midpoint.x, width: originalSize.width, height: originalSize.height))

    let rotatedImage = UIGraphicsGetImageFromCurrentImageContext() ?? originalImage

    UIGraphicsEndImageContext()

    return rotatedImage
}
