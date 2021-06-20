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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let scrollView = scrollView {
            centerScrollViewIfNeeded(scrollView)
        }
    }

    private func centerScrollViewIfNeeded(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.notEmpty else { return }

        let insetX = max(0.0, (scrollView.bounds.width - scrollView.contentSize.width) / 2.0)
        let insetY = max(0.0, (scrollView.bounds.height - scrollView.contentSize.height) / 2.0)
        scrollView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: 0.0, right: 0.0)
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

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewIfNeeded(scrollView)
    }

}


extension CGSize {

    var notEmpty: Bool {
        return self.width > 0.0 && self.height > 0.0
    }

}
