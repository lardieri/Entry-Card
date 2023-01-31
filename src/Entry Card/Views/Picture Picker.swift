//
//  Picture Picker.swift
//  Entry Card
//

import SwiftUI

struct PicturePicker: View {
    @State var isEmpty: Bool = Bool.random()

    struct RotateButton: View {
        var body: some View {
            Button(
                action: {

                },

                label: {
                    Image(systemName: .rotateLeft)
                }
            )
        }
    }

    struct AddButton: View {
        @Binding var isEmpty: Bool

        var body: some View {
            Button(
                action: {
                    isEmpty = false
                },

                label: {
                    Image(systemName: .plus)
                }
            )
        }
    }

    struct DeleteButton: View {
        @Binding var isEmpty: Bool

        var body: some View {
            Button(
                action: {
                    isEmpty = true
                },

                label: {
                    Image(systemName: .trash)
                }
            )
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Image(Images.emptyPicture)
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

                    AddButton(isEmpty: $isEmpty)
                        .hidden(if: !isEmpty)

                    DeleteButton(isEmpty: $isEmpty)
                        .hidden(if: isEmpty)

                    Spacer()
                }

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
}

struct PicturePicker_Previews: PreviewProvider {
    static var previews: some View {
        PicturePicker()
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
