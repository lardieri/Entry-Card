//
//  Pictures tab.swift
//  Entry Card
//

import SwiftUI

fileprivate let columnCount = 3
fileprivate let spacing: CGFloat = 10.0

struct PicturesTab: View {
    @EnvironmentObject var pictures: Pictures

    var columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: columnCount)

    var body: some View {
        HStack {
            Spacer()

            LazyVGrid(columns: columns, alignment: .center, spacing: spacing, pinnedViews: []) {
                ForEach(pictures.collection) { picture in
                    PicturePicker(picture: picture)
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
            let pictures = Pictures()
            PicturesTab()
                .environmentObject(pictures)
        }
    }
}
