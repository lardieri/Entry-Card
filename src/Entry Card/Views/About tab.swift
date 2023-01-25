//
//  About tab.swift
//  Entry Card
//

import SwiftUI

// From UIKit's readable layout guide. No official equivalent in SwiftUI.
fileprivate let maxReadableWidth: CGFloat = 672.0

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
                    .listRowSeparator(.hidden)
            }
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
