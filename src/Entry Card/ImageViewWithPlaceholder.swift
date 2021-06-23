//
//  ImageViewWithPlaceholder.swift
//  Entry Card
//

import UIKit

class ImageViewWithPlaceholder: UIImageView {

    override init(image: UIImage?) {
        if image == nil {
            super.init(image: Self.emptyPicture)
        } else {
            super.init(image: image)
        }
    }

    override init(image: UIImage?, highlightedImage: UIImage?) {
        if image == nil {
            super.init(image: Self.emptyPicture, highlightedImage: highlightedImage)
        } else {
            super.init(image: image, highlightedImage: highlightedImage)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        if image == nil {
            image = Self.emptyPicture
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        if image == nil {
            image = Self.emptyPicture
        }
    }

    override var image: UIImage? {
        get {
            if super.image == nil || super.image == Self.emptyPicture {
                return nil
            } else {
                return super.image
            }
        }

        set {
            if newValue == nil {
                super.image = Self.emptyPicture
            } else {
                super.image = newValue
            }
        }
    }

    static var emptyPicture = UIImage(named: Images.emptyPicture)
    
}
