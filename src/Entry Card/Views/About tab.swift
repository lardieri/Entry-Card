//
//  About tab.swift
//  Entry Card
//
//  Created by Stephen Lardieri on 1/23/2023.
//

import SwiftUI

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

    }
}

struct AboutTab_Previews: PreviewProvider {
    static var previews: some View {
        AboutTab()
    }
}
