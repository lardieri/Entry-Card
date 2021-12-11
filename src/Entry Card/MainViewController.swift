//
//  MainViewController.swift
//  Entry Card
//

import UIKit
import BrightnessToggle

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSettings()
        settingsChangeObserver = AppSettings.observeChanges { [weak self] _ in
            self?.loadSettings()
        }

        if pages.count == 0 {
            self.needsInitialSettings = true
        }

        StorageManager.cleanStorageDirectory()
    }

    override func viewDidAppear(_ animated: Bool) {
        viewHasAppeared = true
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
        updateBrightnessFromSettings()
        updatePagesFromSettings()
    }

    private func updateBrightnessFromSettings() {
        guard AppSettings.useMaximumBrightness != BrightnessToggle.setToMax else { return }
        
        if AppSettings.useMaximumBrightness {
            BrightnessToggle.maxBrightness()
        } else {
            BrightnessToggle.restoreBrightness()
        }
    }

    private func updatePagesFromSettings() {
        var pages = [LoadedPictureViewController]()

        let loadedPictures = StorageManager.loadPictures().compactMap { $0 }
        let existingPictures = (self.pages as! [LoadedPictureViewController]).compactMap { $0.loadedPicture }
        guard loadedPictures != existingPictures else { return }

        for loadedPicture in loadedPictures {
            let page = self.storyboard!.instantiateViewController(withIdentifier: Storyboard.loadedPictureViewController) as! LoadedPictureViewController
            page.loadedPicture = loadedPicture
            pages.append(page)
        }

        self.pages = pages
    }

    private func showInitialSettingsIfNeeded() {
        if needsInitialSettings && viewHasAppeared {
            self.needsInitialSettings = false

            OperationQueue.main.addOperation { [weak self] in
                guard let self = self else { return }
                self.performSegue(withIdentifier: Storyboard.presentSettingsSegue, sender: self)
            }
        }
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

    private var needsInitialSettings = false {
        didSet {
            showInitialSettingsIfNeeded()
        }
    }

    private var viewHasAppeared = false {
        didSet {
            showInitialSettingsIfNeeded()
        }
    }

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
