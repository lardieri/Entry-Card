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

        imageView?.image = loadedPicture?.rotatedImage()
        adjustZoomFactors()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        adjustZoomFactors()
        
        if let scrollView = scrollView {
            centerScrollViewIfNeeded(scrollView)
        }
    }

    private func adjustZoomFactors() {
        guard let scrollView = self.scrollView else { return }
        guard let _ = self.imageView else { return }
        guard let image = loadedPicture?.rotatedImage() else { return }

        let imageSize = image.size
        let viewSize = scrollView.frame.size

        guard imageSize.notEmpty && viewSize.notEmpty else { return }

        let minZoom = 0.95 * min(viewSize.height / imageSize.height, viewSize.width / imageSize.width)
        let maxZoom = 4.0 * minZoom

        scrollView.minimumZoomScale = minZoom
        scrollView.maximumZoomScale = maxZoom

        scrollView.setZoomScale(minZoom, animated: true)
    }

    private func centerScrollViewIfNeeded(_ scrollView: UIScrollView) {
        OperationQueue.main.addOperation {
            guard scrollView.contentSize.notEmpty else { return }

            let insetX = max(0.0, (scrollView.bounds.width - scrollView.contentSize.width) / 2.0)
            let insetY = max(0.0, (scrollView.bounds.height - scrollView.contentSize.height) / 2.0)
            scrollView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: 0.0, right: 0.0)
        }
    }

    var loadedPicture: LoadedPicture? {
        didSet {
            imageView?.image = loadedPicture?.rotatedImage()
            adjustZoomFactors()
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
