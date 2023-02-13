//
//  Picture Picker.swift
//  Entry Card
//

import SwiftUI
import SFSymbolEnum

struct PicturePicker: View {
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

    struct AddButton: View {
        @EnvironmentObject var picture: Picture

        var body: some View {
            Button(
                action: {
                    picture.replace()
                },

                label: {
                    Image(systemName: .plus)
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
                    presentingConfirmation = true
                },

                label: {
                    Image(systemName: .trash)
                }
            )
            .alert("Remove picture?", isPresented: $presentingConfirmation) {
                Button(role: .destructive) {
                    picture.clear()
                } label: {
                    Text("Remove")
                }

                Button(role: .cancel) {

                } label: {
                    Text("Cancel")
                }
            }
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
                    Spacer()

                    RotateButton()
                        .hidden(if: isEmpty)

                    AddButton()
                        .hidden(if: !isEmpty)

                    DeleteButton()
                        .hidden(if: isEmpty)

                    Spacer()
                }
                .environmentObject(picture)

                Spacer(minLength: 8.0)
                    .fixedSize()
            }
            .background(
                .regularMaterial.opacity(0.95),
                in: RoundedRectangle(cornerRadius: 8.0, style: .continuous)
            )
            .frame(maxWidth: .infinity, maxHeight: 30.0)
            .padding(SwiftUI.EdgeInsets(top: 0.0, leading: 4.0, bottom: 8.0, trailing: 4.0))

        }
    }

    private static let placeholder = UIImage(named: Images.emptyPicture)!
}

struct PicturePicker_Previews: PreviewProvider {
    static var previews: some View {
        let picture = Picture(index: 0, loadedPicture: nil)
        PicturePicker(picture: picture)
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
