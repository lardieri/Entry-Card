//
//  Picture cell.swift
//  Entry Card
//

import SwiftUI
import SFSymbolEnum

struct PictureCell: View {
    @ObservedObject var picture: Picture

    var isEmpty: Bool {
        picture.image == nil
    }

    struct RotateButton: View {
        @EnvironmentObject var picture: Picture

        var body: some View {
            Button(
                action: {
                    picture.rotate()
                },

                label: {
                    Image(systemName: .rotateRight)
                }
            )
        }
    }

    struct DeleteButton: View {
        @EnvironmentObject var picture: Picture
        @State var presentingConfirmation = false

        var body: some View {
            Button(
                action: {
                    presentingConfirmation.toggle()
                },

                label: {
                    Image(systemName: .trash)
                }
            )
            .alert("Remove picture?", isPresented: $presentingConfirmation) {
                Button("Remove", role: .destructive) {
                    picture.clear()
                }

                Button("Cancel", role: .cancel) {

                }
            }
        }
    }

    struct AddButton: View {
        @EnvironmentObject var picture: Picture
        @State var presentingConfirmation = false
        @State var presentingFilePicker = false
        @State var imageSourceType: UIImagePickerController.SourceType? = nil

        var body: some View {
            Button(
                action: {
                    presentingConfirmation.toggle()
                },

                label: {
                    Image(systemName: .plus)
                }
            )
            .confirmationDialog("SELECT PICTURE FROM…", isPresented: $presentingConfirmation, titleVisibility: .visible) {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    Button("Camera") {
                        imageSourceType = .camera
                    }
                }

                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    Button("Photos") {
                        imageSourceType = .photoLibrary
                    }
                }

                Button("Files") {
                    presentingFilePicker.toggle()
                }
            }
            .sheet(item: $imageSourceType, content: { sourceType in
                ImagePicker(sourceType: sourceType, index: picture.id) { newImage in

                }
            })
            .fileImporter(isPresented: $presentingFilePicker, allowedContentTypes: [ .heic, .jpeg, .png, .pdf ], onCompletion: { result in
                guard case .success(let url) = result else { return }
                let _ = StorageManager.addPicture(fromURL: url, atPosition: picture.id)
            })

        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Image(uiImage: picture.image ?? Self.placeholder)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .aspectRatio(0.75, contentMode: .fit)
                .padding(1.0)
                .border(.gray, width: 1.0)

            VStack(alignment: .center) {
                Spacer(minLength: 8.0)
                    .fixedSize()

                HStack {
                    if isEmpty {
                        Spacer()
                        AddButton()
                        Spacer()
                    } else {
                        Spacer()
                        RotateButton()
                        Spacer()
                        DeleteButton()
                        Spacer()
                    }
                }
                .environmentObject(picture)

                Spacer(minLength: 8.0)
                    .fixedSize()
            }
            .background(
                .regularMaterial.opacity(0.90),
                in: RoundedRectangle(cornerRadius: 8.0, style: .continuous)
            )
            .frame(maxWidth: .infinity, maxHeight: 30.0)
            .padding(SwiftUI.EdgeInsets(top: 0.0, leading: 4.0, bottom: 8.0, trailing: 4.0))

        }
    }

    private static let placeholder = UIImage(named: Images.emptyPicture)!
}

struct PictureCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let emptyPicture = Picture(index: 0, loadedPicture: nil)
            PictureCell(picture: emptyPicture)
                .previewDevice("iPad Pro (10.5-inch)")

            let loadedPicture = LoadedPicture(originalImage: UIImage(named: "Icon - default")!, filename: "", rotation: 0)
            let picture = Picture(index: 0, loadedPicture: loadedPicture)
            PictureCell(picture: picture)
        }
    }
}


extension View {
    func hidden(if condition: Bool) -> some View {
        if condition {
            return self.opacity(0.0)
        } else {
            return self.opacity(1.0)
        }
    }
}


extension UIImagePickerController.SourceType: Identifiable {
    public var id: Self {
        return self
    }
}
