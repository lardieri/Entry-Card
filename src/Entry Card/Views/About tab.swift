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
                DisclosureGroup("Third Party Credits") {
                    ThirdPartyCredits()
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.insetGrouped)

    }
}

struct AboutTab_Previews: PreviewProvider {
    static var previews: some View {
        AboutTab()
    }
}
