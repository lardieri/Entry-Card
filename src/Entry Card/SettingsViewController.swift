//
//  SettingsViewController.swift
//  Entry Card
//

import UIKit
import UniformTypeIdentifiers

class SettingsViewController: UITableViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var brightnessSwitch: UISwitch!
    @IBOutlet weak var requireUnlockLabel: UILabel!
    @IBOutlet weak var requireUnlockSwitch: UISwitch!

    @IBOutlet var imageViews: [UIImageView]! { didSet { imageViews.sort { $0.tag < $1.tag } } }
    @IBOutlet var addImageButtons: [UIBarButtonItem]! { didSet { addImageButtons.sort { $0.tag < $1.tag } } }
    @IBOutlet var removeImageButtons: [UIBarButtonItem]! { didSet { removeImageButtons.sort { $0.tag < $1.tag } } }
    @IBOutlet var rotateImageButtons: [UIBarButtonItem]! { didSet { rotateImageButtons.sort { $0.tag < $1.tag } } }

    private let borderViewTag = 314159
    private let borderColor = UIColor(named: Colors.tableViewBorder)

    private var loadedPictures: [LoadedPicture?] = []
    private let lockManager = LockManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        brightnessSwitch.setOn(AppSettings.useMaximumBrightness, animated: false)

        if lockManager.available {
            requireUnlockLabel.isEnabled = true
            requireUnlockSwitch.isEnabled = true
            requireUnlockSwitch.setOn(AppSettings.requireUnlock, animated: false)
        } else {
            requireUnlockLabel.isEnabled = false
            requireUnlockSwitch.isEnabled = false
            requireUnlockSwitch.setOn(false, animated: false)
        }

        loadedPictures = StorageManager.loadPictures()

        for index in 0 ..< imageViews.count {
            if index < loadedPictures.count {
                imageViews[index].image = loadedPictures[index]?.rotatedImage()
            } else {
                loadedPictures.append(nil)
                imageViews[index].image = nil
            }

            updateToolbarButtons(forPosition: index)
        }
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

    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView,
              let imageIndex = imageViews.firstIndex(of: imageView) else { return }

        if imageViews[imageIndex].image == nil {
            addImage(forPosition: imageIndex)
        } else {
            rotateImage(forPosition: imageIndex)
        }
    }

    @IBAction func addImageTapped(_ sender: UIBarButtonItem) {
        guard let imageIndex = addImageButtons.firstIndex(of: sender) else { return }
        addImage(forPosition: imageIndex)
    }

    @IBAction func removeImageTapped(_ sender: UIBarButtonItem) {
        guard let imageIndex = removeImageButtons.firstIndex(of: sender) else { return }
        confirmRemoveImage(forButton: sender) { [weak self] remove in
            if remove, let self = self {
                self.imageViews[imageIndex].image = nil
                self.loadedPictures[imageIndex] = nil
                self.updateToolbarButtons(forPosition: imageIndex)
                StorageManager.removePicture(fromPosition: imageIndex)
            }
        }
    }

    @IBAction func rotateImageTapped(_ sender: UIBarButtonItem) {
        guard let imageIndex = rotateImageButtons.firstIndex(of: sender) else { return }
        rotateImage(forPosition: imageIndex)
    }

    @IBAction func brightnessChanged(_ sender: UISwitch, forEvent event: UIEvent) {
        if AppSettings.useMaximumBrightness != sender.isOn {
            AppSettings.useMaximumBrightness = sender.isOn
        }
    }

    @IBAction func requireUnlockChanged(_ sender: UISwitch, forEvent event: UIEvent) {
        guard AppSettings.requireUnlock != sender.isOn else {
            return
        }

        if sender.isOn {
            lockManager.requestUnlock { result in
                switch result {
                    case .succeeded:
                        AppSettings.requireUnlock = true
                    case .failed:
                        sender.setOn(false, animated: true)
                }
            }
        } else {
            AppSettings.requireUnlock = false
        }
    }

    private func addImage(forPosition index: Int) {
        chooseImage(forPosition: index) { [weak self] newImage in
            guard let self = self else { return }
            if let newImage = newImage {
                self.loadedPictures[index] = LoadedPicture(originalImage: newImage, filename: "", rotation: 0)
                self.imageViews[index].image = newImage
            }
            self.updateToolbarButtons(forPosition: index)
        }
    }

    private func rotateImage(forPosition index: Int) {
        guard var loadedPicture = loadedPictures[index] else { return }

        loadedPicture.rotation += 1
        loadedPictures[index] = loadedPicture
        imageViews[index].image = loadedPicture.rotatedImage()

        AppSettings.storedPictures[index].rotation = loadedPicture.rotation
    }

    private func updateToolbarButtons(forPosition index: Int) {
        let hasImage = imageViews[index].image != nil
        addImageButtons[index].isHidden = hasImage
        removeImageButtons[index].isHidden = !hasImage
        rotateImageButtons[index].isHidden = !hasImage
    }

    private func chooseImage(forPosition index: Int, completion: @escaping (UIImage?) -> Void) {

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
            let delegate = ImagePickerControllerDelegate(index: index, completion: completion)
            imagePicker.delegate = delegate

            if let popPC = imagePicker.popoverPresentationController {
                popPC.sourceView = imageView
                popPC.sourceRect = imageView.bounds
                popPC.permittedArrowDirections = .any
            }

            self.present(imagePicker, animated: true, completion: nil)
        }

        func showDocumentPicker() {

            class DocumentPickerWithStrongDelegate: UIDocumentPickerViewController {

                override weak var delegate: (UIDocumentPickerDelegate)? {
                    didSet {
                        strongDelegate = delegate
                    }
                }

                private var strongDelegate: (UIDocumentPickerDelegate)?

            }

            let documentPicker: UIDocumentPickerViewController
            if #available(iOS 14, *) {
                let types: [UTType] = [ .heic, .jpeg, .png, .pdf ]
                documentPicker = DocumentPickerWithStrongDelegate(forOpeningContentTypes: types, asCopy: true)
            } else {
                let types = [ "public.heic", "public.jpeg", "public.jpeg-2000", "public.png", "com.adobe.pdf" ]
                documentPicker = DocumentPickerWithStrongDelegate(documentTypes: types, in: .import)
            }

            let imageView = imageViews[index]
            let delegate = DocumentPickerDelegate(index: index, completion: completion)
            documentPicker.delegate = delegate

            if let popPC = documentPicker.popoverPresentationController {
                popPC.sourceView = imageView
                popPC.sourceRect = imageView.bounds
                popPC.permittedArrowDirections = .any
            }

            self.present(documentPicker, animated: true, completion: nil)
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
            alert.addAction(alertActionWithIcon(title: "Camera", imageName: Images.camera) { _ in
                showImagePicker(for: .camera)
            })
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(alertActionWithIcon(title: "Photos", imageName: Images.photo) { _ in
                showImagePicker(for: .photoLibrary)
            })
        }

        alert.addAction(alertActionWithIcon(title: "Files", imageName: Images.folder) { _ in
            showDocumentPicker()
        })

        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                completion(nil)
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


fileprivate class ImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    init(index: Int, completion: @escaping (UIImage?) -> Void) {
        self.index = index
        self.completion = completion

        super.init()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true) {
            self.completion(nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil

        // Case 1: User edited the picture.
        // The edited picture only exists in memory, and we need to save it.
        if let editedImage = info[.editedImage] as? UIImage {
            if StorageManager.addPicture(fromImage: editedImage, atPosition: index) {
                newImage = editedImage
            }
        }

        // Case 2: User picked an original image from the photo library.
        // We need to copy it in case it gets moved or deleted from the library later.
        else if let imageURL = info[.imageURL] as? URL,
                let originalImage = info[.originalImage] as? UIImage {
            if StorageManager.addPicture(fromURL: imageURL, atPosition: index) {
                newImage = originalImage
            }
        }

        // Case 3: User took a new photo with the camera.
        // The photo only exists in memory, and we need to save it.
        else if let originalImage = info[.originalImage] as? UIImage {
            if StorageManager.addPicture(fromImage: originalImage, atPosition: index) {
                newImage = originalImage
            }
        }

        picker.presentingViewController?.dismiss(animated: true) {
            self.completion(newImage)
        }
    }

    private let index: Int
    private let completion: (UIImage?) -> Void

}


fileprivate class DocumentPickerDelegate: NSObject, UIDocumentPickerDelegate {

    init(index: Int, completion: @escaping (UIImage?) -> Void) {
        self.index = index
        self.completion = completion

        super.init()
    }

    func documentPicker(_ picker: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let imageURL = urls.first,
           StorageManager.addPicture(fromURL: imageURL, atPosition: index),
           let image = UIImage.fromURL(imageURL) {
            completion(image)
        } else {
            completion(nil)
        }
    }

    func documentPickerWasCancelled(_ picker: UIDocumentPickerViewController) {
        completion(nil)
    }

    private let index: Int
    private let completion: (UIImage?) -> Void

}
