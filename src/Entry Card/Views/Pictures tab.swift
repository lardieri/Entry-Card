//
//  Pictures tab.swift
//  Entry Card
//

import SwiftUI

fileprivate let maxPictures = 9
fileprivate let columnCount = 3
fileprivate let spacing: CGFloat = 10.0

struct PicturesTab: View {
    var columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnCount)

    var body: some View {
        HStack {
            Spacer()

            LazyVGrid(columns: columns, alignment: .center, spacing: spacing, pinnedViews: []) {
                ForEach(1...maxPictures, id: \.self) { _ in
                    PicturePicker()
                }
            }
            .padding(spacing)
            .aspectRatio(0.75, contentMode: .fit)

            Spacer()
        }
    }
}

struct PicturesTab_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PicturesTab()
        }
    }
}
