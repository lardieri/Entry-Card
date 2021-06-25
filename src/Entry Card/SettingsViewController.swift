//
//  SettingsViewController.swift
//  Entry Card
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var brightnessSwitch: UISwitch!

    @IBOutlet var imageViews: [UIImageView]! { didSet { imageViews.sort { $0.tag < $1.tag } } }
    @IBOutlet var addImageButtons: [UIBarButtonItem]! { didSet { addImageButtons.sort { $0.tag < $1.tag } } }
    @IBOutlet var removeImageButtons: [UIBarButtonItem]! { didSet { removeImageButtons.sort { $0.tag < $1.tag } } }

    private let borderViewTag = 314159
    private let borderColor = UIColor(named: Colors.tableViewBorder)

    override func viewDidLoad() {
        super.viewDidLoad()

        brightnessSwitch.setOn(AppSettings.useMaximumBrightness, animated: false)

        var toolbarItems = toolbar.items
        for (index, loadedPicture) in StorageManager.loadPictures().enumerated() {
            guard index < imageViews.count else { break }

            if let loadedPicture = loadedPicture {
                imageViews[index].image = loadedPicture.image
                if let buttonIndex = toolbarItems?.firstIndex(of: addImageButtons[index]) {
                    toolbarItems?[buttonIndex] = removeImageButtons[index]
                }
            } else {
                imageViews[index].image = nil
                if let buttonIndex = toolbarItems?.firstIndex(of: removeImageButtons[index]) {
                    toolbarItems?[buttonIndex] = addImageButtons[index]
                }
            }
        }

        self.toolbar.setItems(toolbarItems, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard view.viewWithTag(borderViewTag) == nil else { return }

        let borderView = UIView(frame: .zero)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.tag = borderViewTag
        borderView.backgroundColor = borderColor

        let borderThickness = (traitCollection.userInterfaceStyle == .light ? (1.0  / tableView.window!.screen.scale ) : 1.0)

        view.addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: borderThickness),
        ])
    }

    @IBAction func addImageTapped(_ sender: UIBarButtonItem) {
        if let imageIndex = addImageButtons.firstIndex(of: sender),
           var toolbarItems = toolbar.items,
           let toolbarIndex = toolbarItems.firstIndex(of: sender) {

            let imageView = imageViews[imageIndex]
            chooseImage(forPosition: imageIndex) { [weak self, weak imageView] in
                guard let self = self, let imageView = imageView else { return }

                if imageView.image != nil {
                    toolbarItems[toolbarIndex] = self.removeImageButtons[imageIndex]
                    self.toolbar.setItems(toolbarItems, animated: true)
                }
            }
        }
    }

    @IBAction func removeImageTapped(_ sender: UIBarButtonItem) {
        if let imageIndex = removeImageButtons.firstIndex(of: sender),
           var toolbarItems = toolbar.items,
           let toolbarIndex = toolbarItems.firstIndex(of: sender) {

            confirmRemoveImage(forButton: sender) { [weak self] remove in
                if remove, let self = self {
                    self.imageViews[imageIndex].image = nil

                    toolbarItems[toolbarIndex] = self.addImageButtons[imageIndex]
                    self.toolbar.setItems(toolbarItems, animated: true)

                    StorageManager.removePicture(fromPosition: imageIndex)
                }
            }
        }
    }

    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView,
           let imageIndex = imageViews.firstIndex(of: imageView),
           var toolbarItems = toolbar.items,
           let toolbarIndex = toolbarItems.firstIndex(of: addImageButtons[imageIndex]) {

            chooseImage(forPosition: imageIndex) { [weak self, weak imageView] in
                guard let self = self, let imageView = imageView else { return }

                if imageView.image != nil {
                    toolbarItems[toolbarIndex] = self.removeImageButtons[imageIndex]
                    self.toolbar.setItems(toolbarItems, animated: true)
                }
            }
        }
    }

    @IBAction func brightnessChanged(_ sender: UISwitch, forEvent event: UIEvent) {
        if AppSettings.useMaximumBrightness != sender.isOn {
            AppSettings.useMaximumBrightness = sender.isOn
        }
    }

    private func chooseImage(forPosition index: Int, completion: @escaping () -> Void) {

        class Delegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

            init(vc: SettingsViewController, imageView: UIImageView, index: Int, completion: @escaping () -> Void) {
                self.vc = vc
                self.imageView = imageView
                self.index = index
                self.completion = completion

                super.init()
            }

            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                vc.dismiss(animated: true) {
                    self.completion()
                }
            }

            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                // Case 1: User edited the picture.
                // The edited picture only exists in memory, and we need to save it.
                if let editedImage = info[.editedImage] as? UIImage {
                    if StorageManager.addPicture(fromImage: editedImage, atPosition: index) {
                        imageView.image = editedImage
                    }
                }

                // Case 2: User picked an original image from the photo library.
                // We need to copy it in case it gets moved or deleted from the library later.
                else if let imageURL = info[.imageURL] as? URL,
                        let originalImage = info[.originalImage] as? UIImage {
                    if StorageManager.addPicture(fromURL: imageURL, atPosition: index) {
                        imageView.image = originalImage
                    }
                }

                // Case 3: User took a new photo with the camera.
                // The photo only exists in memory, and we need to save it.
                else if let originalImage = info[.originalImage] as? UIImage {
                    if StorageManager.addPicture(fromImage: originalImage, atPosition: index) {
                        imageView.image = originalImage
                    }
                }

                vc.dismiss(animated: true) {
                    self.completion()
                }
            }

            private let vc: SettingsViewController
            private let imageView: UIImageView
            private let index: Int
            private let completion: () -> Void

        }

        func showImagePicker(for sourceType: UIImagePickerController.SourceType) {

            class ImagePickerWithStrongDelegate: UIImagePickerController {

                override weak var delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
                    didSet {
                        strongDelegate = delegate
                    }
                }

                private var strongDelegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?

            }

            let imagePicker = ImagePickerWithStrongDelegate()

            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = false // Built-in editing just crops to a square.

            let imageView = imageViews[index]
            let delegate = Delegate(vc: self, imageView: imageView, index: index, completion: completion)
            imagePicker.delegate = delegate

            if let popPC = imagePicker.popoverPresentationController {
                popPC.sourceView = imageView
                popPC.sourceRect = imageView.bounds
                popPC.permittedArrowDirections = .any
            }

            self.present(imagePicker, animated: true, completion: nil)
        }

        func alertActionWithIcon(title: String, imageName: String, handler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
            let action = UIAlertAction(title: title, style: .default, handler: handler)

            if let icon = UIImage(named: imageName) {
                action.setValue(icon, forKey: "image")
            }

            return action
        }

        let alert = UIAlertController(title: "SELECT PICTURE", message: nil, preferredStyle: .actionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(alertActionWithIcon(title: "Camera", imageName: Images.camera, handler: { _ in
                showImagePicker(for: .camera)
            }))
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(alertActionWithIcon(title: "Photos", imageName: Images.photo, handler: { _ in
                showImagePicker(for: .photoLibrary)
            }))
        }

        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completion()
            })
        )

        if let popPC = alert.popoverPresentationController {
            let imageView = imageViews[index]
            popPC.sourceView = imageView

            let rect = imageView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: imageView.bounds.height * 0.3, right: 0))
            popPC.sourceRect = rect
            popPC.permittedArrowDirections = .up
        }

        self.present(alert, animated: true, completion: nil)
    }

    private func confirmRemoveImage(forButton removeButton: UIBarButtonItem, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Remove picture?", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:  { _ in completion(false) } ))

        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in completion(true) } ))

        if let popPC = alert.popoverPresentationController {
            popPC.barButtonItem = removeButton
            popPC.permittedArrowDirections = .up
        }

        self.present(alert, animated: true, completion: nil)
    }

}
