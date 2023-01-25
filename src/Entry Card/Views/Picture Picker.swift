//
//  Picture Picker.swift
//  Entry Card
//

import SwiftUI

fileprivate let margin: CGFloat = 0.5

struct PicturePicker: View {
    var body: some View {
        Image(Images.emptyPicture)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .aspectRatio(0.75, contentMode: .fit)
            .padding(margin)
            .border(.gray, width: 1.0)
    }
}

struct PicturePicker_Previews: PreviewProvider {
    static var previews: some View {
        PicturePicker()
    }
}
