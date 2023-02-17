//
//  ImagePicker wrapper.swift
//  Entry Card
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    enum Result {
        case url(URL)
        case image(UIImage)
    }

    typealias Completion = (Result?) -> Void

    let sourceType: UIImagePickerController.SourceType
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
        return ImagePickerControllerDelegate(completion: completion)
    }

    class ImagePickerControllerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        init(completion: @escaping Completion) {
            self.completion = completion

            super.init()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.completion(nil)
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            var result: ImagePicker.Result? = nil

            // Case 1: User edited the picture.
            // The edited picture only exists in memory, and we need to save it.
            if let editedImage = info[.editedImage] as? UIImage {
                result = .image(editedImage)
            }

            // Case 2: User picked an original image from the photo library.
            // We need to copy it in case it gets moved or deleted from the library later.
            else if let imageURL = info[.imageURL] as? URL {
                result = .url(imageURL)
            }

            // Case 3: User took a new photo with the camera.
            // The photo only exists in memory, and we need to save it.
            else if let originalImage = info[.originalImage] as? UIImage {
                result = .image(originalImage)
            }

            self.completion(result)
        }

        private let completion: Completion

    }
}
