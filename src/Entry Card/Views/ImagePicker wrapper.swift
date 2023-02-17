//
//  ImagePicker wrapper.swift
//  Entry Card
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    typealias Completion = (UIImage?) -> Void

    let sourceType: UIImagePickerController.SourceType
    let index: Int
    let completion: Completion

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()

        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = false // Built-in editing just crops to a square.
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    func makeCoordinator() -> ImagePickerControllerDelegate {
        return ImagePickerControllerDelegate(index: index, completion: completion)
    }

    class ImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        init(index: Int, completion: @escaping Completion) {
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
        private let completion: Completion

    }
}
