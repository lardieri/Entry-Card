//
//  About tab.swift
//  Entry Card
//

import SwiftUI

// For comparison, UIKit's readable layout guide is 672.0.
fileprivate let maxReadableWidth: CGFloat = 500.0

struct AboutTab: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    About()
                    Spacer()
                }
            }
            .listRowSeparator(.hidden)

            Section {
                DisclosureGroup(
                    content: {
                        ThirdPartyCredits()
                    },

                    label: {
                        Text("Third Party Credits")
                            .font(.callout.smallCaps())

                    }
                )
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.inset)
        .frame(maxWidth: maxReadableWidth, alignment: .center)

    }
}

struct AboutTab_Previews: PreviewProvider {
    static var previews: some View {
        AboutTab()
    }
}
