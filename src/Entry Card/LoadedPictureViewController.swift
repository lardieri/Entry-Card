//
//  LoadedPictureViewController.swift
//  Entry Card
//

import UIKit

class LoadedPictureViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var imageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView!.delegate = self
        imageView?.image = loadedPicture?.image
    }

    var loadedPicture: StorageManager.LoadedPicture? {
        didSet {
            imageView?.image = loadedPicture?.image
        }
    }

}


extension LoadedPictureViewController: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
