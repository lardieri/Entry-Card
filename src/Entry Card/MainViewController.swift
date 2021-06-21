//
//  MainViewController.swift
//  Entry Card
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSettings()
        settingsChangeObserver = AppSettings.observeChanges { [weak self] _ in
            self?.loadSettings()
        }
    }

    @IBAction func presentedViewControllerDismissed(unwindSegue: UIStoryboardSegue) {

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Storyboard.pageViewControllerEmbeddedSegue) {
            pageVC = (segue.destination as! UIPageViewController)
        }
    }

    deinit {
        if let settingsChangeObserver = settingsChangeObserver {
            AppSettings.stopObservingChanges(settingsChangeObserver)
        }
    }

    private func loadSettings() {

    }

    private func updatePageViewController() {
        guard let pageVC = pageVC else { return }

        if pages.count > 0 {
            pageVC.dataSource = self
            pageVC.delegate = self
            pageVC.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)

            OperationQueue.main.addOperation {
                if let pageControl = pageVC.view.subviews.first(where: { $0 is UIPageControl }) as? UIPageControl {
                    self.customizePageControl(pageControl)
                }
            }
        } else {
            let emptyVC = storyboard!.instantiateViewController(withIdentifier: Storyboard.emptyPictureViewController)

            pageVC.dataSource = nil
            pageVC.delegate = nil
            pageVC.setViewControllers([emptyVC], direction: .forward, animated: false, completion: nil)
        }
    }

    private func customizePageControl(_ pageControl: UIPageControl) {
        if #available(iOS 14.0, *) {
            pageControl.backgroundStyle = .prominent
        }
        
        pageControl.hidesForSinglePage = true
    }

    private var pageVC: UIPageViewController? {
        didSet {
            updatePageViewController()
        }
    }

    private var pages = [UIViewController]() {
        didSet {
            updatePageViewController()
        }
    }

    private var settingsChangeObserver: Any?

}


extension MainViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.firstIndex(of: viewController), index > 0 {
            return pages[index - 1]
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pages.lastIndex(of: viewController), index < pages.count - 1 {
            return pages[index + 1]
        } else {
            return nil
        }
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let currentPage = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: currentPage) {
            return index
        } else {
            return 0
        }
    }

}


extension MainViewController: UIPageViewControllerDelegate {

}
