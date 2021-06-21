//
//  SettingsViewController.swift
//  Entry Card
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var brightnessSwitch: UISwitch!

    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet var addImageButtons: [UIBarButtonItem]!
    @IBOutlet var removeImageButtons: [UIBarButtonItem]!

    private let borderViewTag = 314159
    private let borderColor = UIColor(named: Colors.tableViewBorder)

    override func viewDidLoad() {
        super.viewDidLoad()

        brightnessSwitch.setOn(AppSettings.useMaximumBrightness, animated: false)
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

                if imageView.image != Self.emptyPicture {
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
            imageViews[imageIndex].image = Self.emptyPicture

            toolbarItems[toolbarIndex] = addImageButtons[imageIndex]
            toolbar.setItems(toolbarItems, animated: true)
        }
    }

    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView,
           let imageIndex = imageViews.firstIndex(of: imageView),
           var toolbarItems = toolbar.items,
           let toolbarIndex = toolbarItems.firstIndex(of: addImageButtons[imageIndex]) {

            chooseImage(forPosition: imageIndex) { [weak self, weak imageView] in
                guard let self = self, let imageView = imageView else { return }

                if imageView.image != Self.emptyPicture {
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
                completion()
            }))
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(alertActionWithIcon(title: "Photos", imageName: Images.photo, handler: { _ in
                completion()
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

    private static let emptyPicture = UIImage(named: Images.emptyPicture)

}
